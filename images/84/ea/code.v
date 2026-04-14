module shift_register_32bit (
    input clk,
    input rst_n,
    input load,
    input shift,
    input [31:0] parallel_in,
    output reg serial_out
);

reg [31:0] shift_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        shift_reg <= 32'b0;
        serial_out <= 1'b0;
    end else if (load) begin
        shift_reg <= parallel_in;
        serial_out <= parallel_in[0];
    end else if (shift) begin
        serial_out <= shift_reg[0];
        shift_reg <= {1'b0, shift_reg[31:1]};
    end
end

endmodule