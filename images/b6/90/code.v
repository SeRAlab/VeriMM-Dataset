module top_module(
    input clk,
    input load,
    input [1:0] ena, // 2-bit input to choose direction and shift/hold
    input [99:0] data, // 100-bit input to shift register
    output reg [99:0] q, // 100-bit output from shift register
    input [7:0] d, // 8-bit input to register
    output reg [7:0] q_reg, // 8-bit output from register
    output reg [7:0] and_output // 8-bit output from functional module
);reg [99:0] shift_reg;
reg [7:0] reg_data;

always @(posedge clk) begin
    if (load) begin
        shift_reg <= data;
        reg_data <= d;
    end else begin
        case (ena)
            2'b00: begin // hold
                shift_reg <= shift_reg;
            end
            2'b01: begin // shift left
                shift_reg <= {shift_reg[98:0], shift_reg[99]};
            end
            2'b10: begin // shift right
                shift_reg <= {shift_reg[0], shift_reg[99:1]};
            end
            2'b11: begin // hold
                shift_reg <= shift_reg;
            end
        endcase
        reg_data <= reg_data;
    end
end

assign q = shift_reg;
assign q_reg = reg_data;

assign and_output = q[7:0] & q_reg;

endmodule