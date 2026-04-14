module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q,
    output reg out_if_else
);reg [99:0] shift_reg;
reg [99:0] rotated_data;

always @(posedge clk) begin
    if (load) begin
        shift_reg <= data;
    end else begin
        case (ena)
            2'b00: rotated_data <= {shift_reg[98:0], shift_reg[99]};
            2'b01: rotated_data <= {shift_reg[97:0], shift_reg[99:98]};
            2'b10: rotated_data <= {shift_reg[99], shift_reg[98:0]};
            2'b11: rotated_data <= {shift_reg[99:98], shift_reg[97:0]};
        endcase
    end
end

always @* begin
    if (data[0] ^ data[1]) begin
        out_if_else = 1'b1;
    end else begin
        out_if_else = 1'b0;
    end
end

assign q = data ^ rotated_data;

endmodule