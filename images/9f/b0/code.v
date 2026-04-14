module top_module(
                    clk_i,
                    rst_n,
                    stall,
                    data_i,
                    data_o
                    );parameter size = 0;

input                  clk_i;
input                  rst_n;          
input                  stall;
input      [size-1: 0] data_i;
output reg [size-1: 0] data_o;
      
always @(negedge rst_n or posedge clk_i) begin
    case(rst_n)
        1'b0: data_o <= 0;
        1'b1: begin
            case(stall)
                1'b0: data_o <= data_i;
                1'b1: data_o <= 0;
            endcase
        end
    endcase
end

endmodule