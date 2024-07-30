 `timescale 1ns / 1ps

module tlc(
    input clk, rst, x, pb,
    output reg [1:0] highway, country,
    output reg pedestrian_light
);
integer timer = 3;
reg [1:0] state, next_state;
reg [1:0] counter_s1, counter_s2, counter_s3; // Counters for each state
parameter HW_red = 2'b00, HW_yellow = 2'b01, HW_green = 2'b10;
parameter CR_red = 2'b00, CR_yellow = 2'b01, CR_green = 2'b10;
parameter s0 = 2'b00, s1 = 2'b01, s2 = 2'b10, s3 = 2'b11;
parameter walk = 1'b1, stop = 1'b0;

// Initialization
initial begin
    state <= s0;
    highway <= HW_green;
    country <= CR_red;
    end

//Reset Condition & Counter Increment
always @(posedge clk) begin
    if (rst) begin
        state <= s0;
        counter_s1 <= 0;
        counter_s2 <= 0;
        counter_s3 <= 0;
    end
    else begin
        state <= next_state;
        // Increment counters based on state
        case(state)
            s1: counter_s1 <= (counter_s1 == timer) ? 0 : counter_s1 + 1;
            s2: counter_s2 <= (counter_s2 == timer) ? 0 : counter_s2 + 1;
            s3: counter_s3 <= (counter_s3 == timer) ? 0 : counter_s3 + 1;
            default: begin
                counter_s1 <= 0;
                counter_s2 <= 0;
                counter_s3 <= 0;
            end
        endcase
    end
end

//Transition Logic
always @(*) begin
    case(state)
        s0: next_state = (x || pb) ? s1 : s0;
        s1: next_state = (counter_s1 == timer) ? s2 : s1;
        s2: next_state = ((counter_s2 == timer) && !(x || pb)) ? s3 : s2;
        s3: next_state = (counter_s3 == timer) ? s0 : s3;
        default: next_state = s0;
    endcase
end

//Output Logic
always @(*) begin
    case(state)
        s0: begin
            highway = HW_green;
            country = CR_red;
            pedestrian_light = stop;
        end
        s1: begin
            highway = HW_yellow;
            country = CR_red;
            pedestrian_light = stop;
        end
        s2: begin
            highway = HW_red;
            country = CR_green;
            pedestrian_light = walk;
        end
        s3: begin
            highway = HW_red;
            country = CR_yellow;
            pedestrian_light = stop;
        end
        default: begin
            highway = HW_green;
            country = CR_red;
            pedestrian_light = stop;
        end
    endcase
end

endmodule
