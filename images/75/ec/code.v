module top_module(
    input clk,
    input reset,
    input shift_en,
    input load_en,
    input [3:0] data_in,
    output [3:0] data_out
);reg [3:0] reg_out;
    reg [3:0] reg_in;

    always @(posedge clk) begin
        if (reset) begin
            reg_out <= 4'b0000;
        end else if (load_en) begin
            reg_out <= data_in;
        end else if (shift_en) begin
            reg_out <= {reg_out[2:0], reg_in};
        end
    end

    assign data_out = reg_out;

endmodule