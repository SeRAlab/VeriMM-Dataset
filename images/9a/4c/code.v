module top_module(clk, reset_n, start, count_target, count, done);parameter COUNT_WIDTH = 32;
    parameter CLK_FREQ = 50_000_000;
    
    input clk;
    input reset_n;
    input start;
    input [COUNT_WIDTH-1:0] count_target;
    
    output reg [COUNT_WIDTH-1:0] count;
    output reg done;
    
    reg [COUNT_WIDTH-1:0] next_count;
    
    always @(posedge clk, negedge reset_n) begin
        if(!reset_n) begin
            count <= 0;
            done <= 0;
        end
        else if(start) begin
            next_count <= count + 1;
            count <= next_count;
            if(next_count == count_target) begin
                done <= 1;
            end
        end
        else begin
            done <= 0;
        end
    end
endmodule