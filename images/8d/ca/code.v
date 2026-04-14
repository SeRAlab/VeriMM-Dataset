module top_module(
    input clk,
    input rst,
    input mode,
    input [3:0] a,
    input [3:0] b,
    output [3:0] result,
    output carry_out
);reg [4:0] temp_result;
reg carry_out_int;

always @(posedge clk) begin
    if (rst) begin
        temp_result <= 5'b0;
        carry_out_int <= 1'b0;
    end else begin
        if (mode == 1'b0) begin // addition
            temp_result <= {1'b0, a} + {1'b0, b};
            carry_out_int <= temp_result[5];
        end else begin // subtraction
            temp_result <= {1'b0, a} - {1'b0, b};
            carry_out_int <= temp_result[5];
        end
    end
end

assign result = temp_result[3:0];
assign carry_out = carry_out_int;

endmodule