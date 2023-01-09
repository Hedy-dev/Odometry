//`include "timer.v"
//`include "coordinate_calculation.v"
`include "pulses_counter_left.v"
`include "data_transfer.v"
module top (
input  clk,
input signalA, //количество тиков будем получать с канала А
output LED0,
output LED1,
output LED2,
output LED3,
output LED4,
output LED5,
output LED6,
output LED7,
output uart_txd // uart_tx
);

// O(t) - положение робота в момент времени t
// Dr — расстояние, пройденное правым колесом робота
// Dl — расстояние, пройденное левым колесом робота
// W — ширина робота

// Для отображения координат робота на карте можно рассчитать его Декартовы координаты
// X(t+1) = X(t) + D(t,t+1)*cos(O(t+1))
// D(t,t+1) = (Dr + Dl)/2
// Новое положение центра O робота в момент времени t+1 будет составлять (в радианах)
// O(t+1)  = O(t) + (Dr - Dl)/W 

// L — итоговое пройденное расстояние (за заданный промежуток времени) 
// L = n/N*C = n/N*2*pi*R
// n — суммарное число отсчётов энкодера (за заданный промежуток времени)
// N — число отсчётов энкодера за один оборот колеса
// R — радиус колеса (D — диаметр колеса)
// C = 2*PI*R = PI*D длина окружности, где R — радиус колеса (соответственно, D — диаметр колеса)
reg [7:0]  pulses_namber;
reg         data_rdy;
reg         data_rdy_r;
reg         transm_rdy;
reg         tx;
reg  [7:0]  pulses_namber_r;   
reg         uart_txd;
wire signalA;
wire signalB;

assign tx = uart_txd;
assign pulses_namber_r = pulses_namber;
//assign data_rdy = data_rdy_r;
//assign PORT1_r = PORT1;
// таймер
// 
//
//pwm_timer pt(CLK, PORT1);
//timer tmr(CLK, t, stop_flag);
// подсчет тиков за t левого колеса
pulses_counter_left pcl(clk, signalA, pulses_namber);
uart_data_transfer udt (clk, pulses_namber_r, data_rdy, tx, transm_rdy);
// правого колеса
// pulses_counter_right pcr();
// вычисление координат
// coordinate_calculation pc(clk, pulses_namber, pulses_namber, robot_width, wheel_circuit, x, y);
// передача 
// always @(negedge clk) begin
//     if (transm_rdy == 1'b1) begin
//         //data <= 8'd254;
//         data_rdy <= 1'b1;
//     end
//     else begin
//         data_rdy <= 1'b0;
//     end

// end


//wheel_speed ws(CLK, signalA, wheel_speed_angle_module);
//direction_of_rotation dor(CLK, LED_r, LED_l, signalA, signalB);
// assign LED1 = pulses_namber[1];
// assign LED2 = pulses_namber[2];
// assign LED3 = pulses_namber[3];
// assign LED4 = pulses_namber[4];
// assign LED5 = pulses_namber[5];
// assign LED6 = pulses_namber[6];
// assign LED7 = pulses_namber[7];
endmodule 