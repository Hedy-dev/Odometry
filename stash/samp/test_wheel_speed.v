module test_counter;

reg  CLK;
wire [7:0] pulses_namber_r;
reg signal;
wire rst_flag;
//устанавливаем экземпляр тестируемого модуля
wheel_speed ws(CLK, signal, pulses_namber_r, rst_flag);
//моделируем сигнал тактовой частоты
always
begin
  #10 CLK = ~CLK;
  #20  signal = ~signal;
//от начала времени...
end
initial
begin
  CLK = 0;
  signal = 0;
end

//заканчиваем симуляцию в момент времени "400"
initial
begin
  #400000 $finish;
end

//создаем файл VCD для последующего анализа сигналов
initial
begin
  $dumpfile("ws_out.vcd");
  $dumpvars(0,test_counter);
end

//наблюдаем на некоторыми сигналами системы
initial
$monitor($stime,, rst_flag,, pulses_namber_r,,, signal,, CLK);

endmodule