// O(t) - положение робота в момент времени t
// Dr — расстояние, пройденное правым колесом робота
// Dl — расстояние, пройденное левым колесом робота
// W robot_width — ширина робота

// Для отображения координат робота на карте можно рассчитать его Декартовы координаты
// X(t+1) = X(t) + D(t,t+1)*cos(O(t+1))
// Y(t+1) = Y(t) + D(t,t+1)*sin(O(t+1))
// D(t,t+1) = (Dr + Dl)/2
// Новое положение центра O робота в момент времени t+1 будет составлять (в радианах)
// O(t+1)  = O(t) + (Dr - Dl)/W 

// L — итоговое пройденное расстояние (за заданный промежуток времени) 
// L = n/N*C = n/N*2*pi*R
// n — суммарное число отсчётов энкодера (за заданный промежуток времени)
// N — число отсчётов энкодера за один оборот колеса
// R — радиус колеса (D — диаметр колеса)
// C = 2*PI*R = PI*D длина окружности, где R — радиус колеса (соответственно, D — диаметр колеса)
`include "Division.v"
`include "Multiplication.v"
`include "Addition_Subtraction.v"
`include "sine_cosine.v"
`default_nettype none
module coordinate_calculation (
input      CLK,
input wire [31:0] pulses_namber_left,
input wire [31:0] pulses_namber_right,
input wire [31:0] robot_width,
input wire [31:0] wheel_circuit,
input wire ready,
output reg [31:0] x,
output reg [31:0] y
);


//reg [7:0] N = 8'd400;
reg [31:0] O_t = 8'd0;
//reg [7:0] O_t1 = 8'd0;
reg [31:0] X_t = 8'd0;
reg [31:0] X_t1 = 8'd0;
reg [31:0] Y_t = 8'd0;
reg [31:0] Y_t1 = 8'd0;

reg       start = 1'b1;


reg O_t1_cur = 0;
reg D_t1 = 0;
reg Dr = 0;
reg Dl = 0;
real N = 400;

function  [31:0]  coordinate_x;
input [31:0]  pulses_namber_left;
input [31:0] pulses_namber_right;
input [31:0] N;
input [31:0] robot_width;
input [31:0] wheel_circuit;
input [31:0] O_t;
input [31:0] X_t;
reg [31:0] X_t1;
reg [31:0] coordinate_x;
reg [31:0] O_t1;
reg [31:0] D_t1, D_t1_2;
reg [31:0] Dr;
reg [31:0] Dl;
reg [31:0] O_t1_new;
reg [31:0] D_lr_sub;
reg [31:0] cos_x;
reg [31:0] sin_x;
reg Xin, Yin;
reg Exception2, Overflow2, Underflow2, Exception_add3;
reg Exception_mlp, Overflow, Underflow, Exception_div1, Exception_div2, Exception_div3, Exception_sub, Exception_add1, Exception_add2, Exception_div4;
begin
    Multiplication mlp1(N, wheel_circuit, Exception, Overflow, Underflow, NWC);
    Division div1(pulses_namber_left, NWC, Exception_div, Dl);
    //Dl = pulses_namber_left/N*wheel_circuit;
    //Multiplication mlp(N, wheel_circuit, Exception,Overflow,Underflow, NWC);
    Division div2(pulses_namber_right, NWC, Exception_div, Dr);
    //Dr = pulses_namber_right/N*wheel_circuit;
    Addition_Subtraction as1(Dr, Dl,1, Exception_sub, D_lr_sub);
    Division div3(D_lr_sub, robot_width, Exception_div3, O_t1_new);
    Addition_Subtraction as2(O_t1_new, O_t1_cur, 0, Exception_add1, O_t1);
    //O_t1 = O_t + (Dr - Dl)/robot_width;
    O_t1_cur <= O_t1;
    Addition_Subtraction as3(Dr, Dl, 0, Exception_add2, D_t1_2);
    Division div4(D_t1_2, 2, Exception_div4, D_t1);
    //D_t1 = D_t1_2/2;


    CORDIC TEST_RUN(CLK, cos_x, sin_x, Xin, Yin, O_t1);


    Multiplication mlp2(D_t1, cos_x, Exception2, Overflow2, Underflow2, X_t1);
    Addition_Subtraction as3(X_t, X_t1, 0, Exception_add3, coordinate_x);
    //coordinate_x = X_t + D_t1*$cos(O_t1);
    

end
endfunction
//sin cos Ряд Тейлора или CORDIC

function [31:0]  coordinate_y;
input [31:0]  pulses_namber_left;
input [31:0] pulses_namber_right;
input [31:0] N;
input [31:0] robot_width;
input [31:0] wheel_circuit;
input [31:0] O_t;
input [31:0] Y_t;
reg [31:0] Y_t1;
reg [31:0] coordinate_y;
reg [31:0] O_t1;
reg [31:0] D_t1, D_t1_2;
reg [31:0] Dr;
reg [31:0] Dl;
reg [31:0] O_t1_new;
reg [31:0] D_lr_sub;
reg [31:0] sin_x, cos_x;
reg Xin, Yin;
reg Exception2, Overflow2, Underflow2, Exception_add3;
reg Exception_mlp, Overflow, Underflow, Exception_div1, Exception_div2, Exception_div3, Exception_sub, Exception_add1, Exception_add2, Exception_div4;
begin
    Multiplication mlp1(N, wheel_circuit, Exception, Overflow, Underflow, NWC);
    Division div1(pulses_namber_left, NWC, Exception_div, Dl);
    //Dl = pulses_namber_left/N*wheel_circuit;
    //Multiplication mlp(N, wheel_circuit, Exception,Overflow,Underflow, NWC);
    Division div2(pulses_namber_right, NWC, Exception_div, Dr);
    //Dr = pulses_namber_right/N*wheel_circuit;
    Addition_Subtraction as1(Dr, Dl,1, Exception_sub, D_lr_sub);
    Division div3(D_lr_sub, robot_width, Exception_div3, O_t1_new);
    Addition_Subtraction as2(O_t1_new, O_t1_cur, 0, Exception_add1, O_t1);
    //O_t1 = O_t + (Dr - Dl)/robot_width;
    O_t1_cur <= O_t1;
    Addition_Subtraction as3(Dr, Dl, 0, Exception_add2, D_t1_2);
    Division div4(D_t1_2, 2, Exception_div4, D_t1);
    //D_t1 = D_t1_2/2;

    CORDIC TEST_RUN(CLK, cos_x, sin_x, Xin, Yin, O_t1);


    Multiplication mlp2(D_t1, sin_x, Exception2, Overflow2, Underflow2, Y_t1);
    Addition_Subtraction as3(Y_t, Y_t1, 0, Exception_add3, coordinate_y);
    
    
    
    //coordinate_y = X_t + D_t1*$sin(O_t1);
end
endfunction

always@(posedge ready) begin
    if (start)
    begin
        x <= 32'd0;
        start <= 1'b0;
        y <= 32'b0;
        
        O_t <= 8'd0;
        O_t1 <= 8'd0;
        X_t <= 8'd0;
        Y_t <= 8'd0;

    end else begin
        Y_t <= y;
        X_t <= x;
        O_t <= O_t1;
        // запоминать значение O_t 
        // кэш из функции 
        y <= coordinate_y(pulses_namber_left, pulses_namber_right, N, robot_width, wheel_circuit, O_t, Y_t);
        x <= coordinate_x(pulses_namber_left, pulses_namber_right, N, robot_width, wheel_circuit, O_t, X_t);
    end
    //x = 8'd1 + coordinate_x(pulses_namber_left, pulses_namber_right, N, robot_width, wheel_circuit, O_t, X_t);
    // y <= 8'd1 + coordinate_x(pulses_namber_left, pulses_namber_right, N, robot_width, wheel_circuit, O_t, Y_t);

    // Dl = pulses_namber_left/N*wheel_circuit;
    // Dr = pulses_namber_right/N*wheel_circuit;
    // O_t1 = O_t + (Dr - Dl)/robot_width;
    // D_t1 = (Dr + Dl)/2;
    // x <=  cos(0.6);
    //x <= X_t + D_t1*cos(O_t1);
   // y <= Y_t + D_t1*sin(O_t1);
end    
// Y_t1 = Y_t + D_t1*sin(O_t1)
// X_t1 = X_t + D_t1*sin(O_t1)
endmodule

//TODO: подсчет ремени вычислений
//Нельзя подключать модули внутри функции??