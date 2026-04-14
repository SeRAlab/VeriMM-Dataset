module top_module(
    input clk,
    input load,
    input ena,
    input clr,
    input [1:0] amount,
    input [7:0] data,
    output reg [7:0] q);

    always @(posedge clk) begin
        if (clr) begin
            q <= 8'b00000000;
        end else if (load) begin
            q <= data;
        end else if (ena) begin
            case (amount)
                2'b00: q <= q << 1;     // Shift left by 1 bit
                2'b01: q <= q << 4;     // Shift left by 4 bits
                2'b10: q <= q >> 1;     // Shift right by 1 bit
                2'b11: q <= q >> 4;     // Shift right by 4 bits
                default: q <= q;        // No change
            endcase
        end
    end

endmodule