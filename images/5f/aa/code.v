module top_module(
    input clk,
    input load,
    input ena,
    input clr,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q);

    always @(posedge clk) begin
        if (clr) begin
            q <= 64'b0;
        end else if (load) begin
            q <= data;
        end else if (ena) begin
            case (amount)
                2'b00: q <= q <<< 1;     // Arithmetic shift left by 1 bit
                2'b01: q <= q <<< 4;     // Arithmetic shift left by 4 bits
                2'b10: q <= q >>> 1;     // Arithmetic shift right by 1 bit
                2'b11: q <= q >>> 4;     // Arithmetic shift right by 4 bits
                default: q <= q;        // No change
            endcase
        end
    end

endmodule