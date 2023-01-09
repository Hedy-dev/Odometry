module test_counter;

reg  CLK;
//wire [7:0] pulses_namber_r;
reg signalA, uart_rx, signalB;
wire rst_flag, uart_txd;
wire  [7:0] rx_byte_parametrs_r1;
wire  [7:0] data;
wire data_rdy;

//устанавливаем экземпляр тестируемого модуля
top tp (CLK, uart_txd, uart_rx, signalA, signalB, rx_byte_parametrs_r1, data, data_rdy);
// output reg [7:0] rx_byte_parametrs_r1,
// output reg [7:0] data,
// reg data_rdy
//моделируем сигнал тактовой частоты
always
begin
  #10 CLK = ~CLK;
  #20  signalA = ~signalA;
//от начала времени...
end
initial
begin
  CLK = 0;
  signalA = 0;
end

//заканчиваем симуляцию в момент времени "400"
initial
begin
  #4000000 $finish;
end

//создаем файл VCD для последующего анализа сигналов
initial
begin
  $dumpfile("ws_out.vcd");
  $dumpvars(0,test_counter);
end

//наблюдаем на некоторыми сигналами системы
initial
$monitor($stime,, data,, data_rdy,,, rx_byte_parametrs_r1,, CLK, signalA);

endmodule