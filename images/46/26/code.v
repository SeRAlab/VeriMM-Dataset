module top_module(
    input clk, rst_n, 
    input [1:0] op, 
    input [7:0] data_in, 
    output reg [7:0] result
);reg [7:0] data_reg;

    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            data_reg <= 8'b0;
            result <= 8'b0;
        end else begin
            data_reg <= data_in;
            case (op)
                2'b00: result <= data_reg + result;
                2'b01: result <= result - data_reg;
                2'b10: result <= data_reg * result;
                2'b11: if (data_reg == 8'b0) begin
                            result <= 8'b0;
                        end else begin
                            result <= result / data_reg;
                        end
            endcase
        end
    end
endmodule