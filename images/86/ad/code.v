module top_module(
    input clk,
    input [3:0] stock,
    output reg hay          
    );always @(posedge clk) begin       
            case(stock)
                4'b0000: hay = 0;   
                default: hay = 1;   
            endcase
    end
endmodule