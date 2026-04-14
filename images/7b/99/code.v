module top_module(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [7:0] data,
    output reg [7:0] q);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            case (amount)
                2'b00: q <= q <<< 1;  // Arithmetic shift left by 1 bit
                2'b01: q <= q <<< 2;  // Arithmetic shift left by 2 bits
                2'b10: q <= q >>> 1;  // Arithmetic shift right by 1 bit
                2'b11: q <= q >>> 2;  // Arithmetic shift right by 2 bits
                default: q <= q;      // No change
            endcase
        end
    end

endmodule