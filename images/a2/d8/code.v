module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [15:0] data,
    output reg [15:0] q,
    output wire [2:0] final_output
);reg [15:0] shift_reg;
reg [2:0] mod_output;

always @(posedge clk) begin
    if (load) begin
        shift_reg <= data;
        q <= data;
    end else begin
        case (ena)
            2'b00: shift_reg <= {shift_reg[13:0], shift_reg[15:14]};
            2'b01: shift_reg <= {shift_reg[14:0], shift_reg[15]};
            2'b10: shift_reg <= {shift_reg[1:0], shift_reg[15:2]};
            2'b11: shift_reg <= {shift_reg[2:0], shift_reg[15:3]};
        endcase
        q <= shift_reg;
    end
end

assign mod_output = shift_reg[2:0] % 8;

assign final_output = ~mod_output;

endmodule