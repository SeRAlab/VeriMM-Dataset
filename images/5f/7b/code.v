module top_module(
    input clk,
    input load,
    input ena,
    input clr,
    input [1:0] amount,
    input [127:0] data,
    output reg [127:0] q);

    always @(posedge clk) begin
        if (clr) begin
            q <= 128'b0;
        end else if (load) begin
            q <= data;
        end else if (ena) begin
            case (amount)
                2'b00: q <= q << 1;     // Shift left by 1 bit
                2'b01: q <= q << 16;    // Shift left by 16 bits
                2'b10: q <= q >> 1;     // Shift right by 1 bit
                2'b11: q <= q >> 16;    // Shift right by 16 bits
                default: q <= q;        // No change
            endcase
        end
    end

endmodule