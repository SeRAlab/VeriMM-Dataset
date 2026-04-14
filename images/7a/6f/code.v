module top_module(
    input clk,
    input load,
    input ena,
    input [2:0] amount,
    input [63:0] data,
    output reg [63:0] q);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            case (amount)
                3'b000: q <= q << 1;     // Shift left by 1 bit
                3'b001: q <= q << 8;     // Shift left by 8 bits
                3'b010: q <= q << 16;    // Shift left by 16 bits
                3'b100: q <= q >> 1;     // Shift right by 1 bit
                3'b101: q <= q >> 8;     // Shift right by 8 bits
                3'b110: q <= q >> 16;    // Shift right by 16 bits
                default: q <= q;         // No change
            endcase
        end
    end

endmodule