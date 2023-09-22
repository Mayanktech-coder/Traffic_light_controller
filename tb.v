`timescale 1ns / 1ps

module tb_traffic_light_controller;
reg CLK, RST, Pedestrian_BTN;
wire RED, YELLOW, GREEN, WALK_light, STOP_light;

traffic_light_controler dut(.clk(CLK),
     .rst(RST),
     .red(RED), 
     .yellow(YELLOW), 
     .green(GREEN), 
     .pedestrian_btn(Pedestrian_BTN), 
     .walk_light(WALK_light), 
     .stop_light(STOP_light)); //Initialization of the Verilog_Module

initial begin //Declaration of Initial Values
RST <= 1'b1;
CLK <= 1'b0; 
Pedestrian_BTN <= 1'b0;
#5 RST <= 1'b0;
end

always begin
#5 CLK = ~CLK;  // Initialization of CLOCK
end

initial begin
//#10 Pedestrian_BTN <= 1;
#9 Pedestrian_BTN <= 0;
#9 Pedestrian_BTN <= 1;
#9 Pedestrian_BTN <= 0;
#5 Pedestrian_BTN <= 1;
#10 Pedestrian_BTN <= 0;
#9 Pedestrian_BTN <= 0;
#9 Pedestrian_BTN <= 0;
#9 Pedestrian_BTN <= 0;
#9 Pedestrian_BTN <= 0;
#9 Pedestrian_BTN <= 0;
#50 $finish;
end
endmodule
