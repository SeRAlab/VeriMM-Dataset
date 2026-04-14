module top_module(
    input clk,
    input reset,      // Asynchronous active-high reset
    input [3:0] input1,
    input [3:0] input2,
    output reg [3:0] sum,
    output reg [3:0] counter_out);reg [3:0] counter;
    reg [3:0] input1_prev;
    reg [3:0] input2_prev;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0000;
            input1_prev <= 4'b0000;
            input2_prev <= 4'b0000;
        end
        else begin
            counter <= counter + 1;
            if (counter == 4'b1111) begin
                counter <= 4'b0000;
            end
            
            input1_prev <= input1;
            input2_prev <= input2;
        end
    end
    
    assign sum = input1 + input2_prev;
    assign counter_out = counter;
    
endmodule