module c;

reg ready, CLK;
reg [7:0] pulses_namber_left, pulses_namber_right, robot_width, wheel_circuit;
wire [31:0] x, y;

//устанавливаем экземпляр тестируемого модуля


coordinate_calculation cc(
CLK,
pulses_namber_left,
pulses_namber_right,
robot_width,
wheel_circuit,
ready,
x,
y
);

//моделируем сигнал тактовой частоты
always
  #10 CLK = ~CLK;

//от начала времени...

initial

begin
  CLK = 0;
  ready = 0;
  pulses_namber_left = 8'd83;
  pulses_namber_right = 8'd83;
  robot_width = 8'd50;
  wheel_circuit = 8'd62;

//через временной интервал "50" подаем сигнал сброса
  #50 ready = 1;

//еще через время "4" снимаем сигнал сброса

  #4 ready = 0;

//пауза длительностью "50"
  #50;

//ждем фронта тактовой частоты и сразу после нее подаем сигнал записи
  @(posedge CLK)
  #0
    begin
      pulses_namber_left  = pulses_namber_left + 8'd1;
      ready = 1;
    end

//по следующему фронту снимаем сигнал записи
  @(posedge CLK)
  #0
    begin
      pulses_namber_right = pulses_namber_right + 8'd1;
      ready = 0;
    end
end

//заканчиваем симуляцию в момент времени "400"
initial
begin
  #400 $finish;
end

//создаем файл VCD для последующего анализа сигналов
initial
begin
  $dumpfile("c.vcd");
  $dumpvars(0,c);
end

//наблюдаем на некоторыми сигналами системы
initial
$monitor($stime,, pulses_namber_left,, pulses_namber_right,,, ready,, x,, y);

endmodule