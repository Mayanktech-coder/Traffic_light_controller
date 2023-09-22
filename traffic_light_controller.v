`timescale 1ns / 1ps

module traffic_light_controler(
input clk, rst, pedestrian_btn,
output reg red, yellow, green, walk_light, stop_light
    );
//Definition of States
    parameter RED_light = 2'b00;
    parameter Yellow_light = 2'b01;
    parameter Green_light = 2'b10;
    parameter Pedestrian_Crossing = 2'b11;
    
reg [1:0] next_state, present_state;
reg pedestrian_RED, pedestrian_Yellow, pedestrian_Green;

//Initial values of States
initial begin
red <= 1'b0;
green <= 1'b0;
yellow <= 1'b0;
walk_light <= 1'b0;
stop_light <= 1'b0;
end
 //Initial Conditions
always @(posedge clk )
begin
if (rst) present_state <= RED_light;
else present_state <= next_state;
end

//Transition Logic
always @(present_state) begin
    case(present_state)
        RED_light: begin
            pedestrian_RED <= pedestrian_btn;
            next_state <= Yellow_light;
            end
        Yellow_light: begin
             pedestrian_Yellow <= pedestrian_btn;
             next_state <= Green_light;
            end
        Green_light: begin
            pedestrian_Green = pedestrian_btn;
            if(pedestrian_RED || pedestrian_Yellow || pedestrian_Green) 
                begin 
                next_state = Pedestrian_Crossing; 
                end
            else next_state <= RED_light; end
        Pedestrian_Crossing: next_state <= RED_light;
        default:next_state = RED_light;
    endcase
end

//Output Logic
always @(present_state) begin
case(present_state) 
    RED_light:begin 
        red <= 1'b1;
        yellow <= 1'b0;
        green <= 1'b0; 
        walk_light <= 1'b0;
        stop_light <= 1'b1;
        end
    Yellow_light:begin 
        red <= 1'b0;
        yellow <= 1'b1;
        green <= 1'b0; 
        walk_light <= 1'b0;
        stop_light <= 1'b1;
        end
    Green_light:begin 
        red <= 1'b0;
        yellow <= 1'b0;
        green <= 1'b1; 
        walk_light <= 1'b0;
        stop_light <= 1'b1;
        end
    Pedestrian_Crossing: begin
        red <= 1'b1;
        yellow <= 1'b0;
        green <= 1'b0;
        walk_light <= 1'b1;
        stop_light <= 1'b0;
        end
    default:begin 
        red <= 1'b1;
        yellow <= 1'b0;
        green <= 1'b0; 
        walk_light <= 1'b0;
        stop_light <= 1'b1;
        end
 endcase
end

endmodule
