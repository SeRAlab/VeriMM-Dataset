module top_module(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            case (amount)
                2'b00: q <= {q[62:0], q[63]};      // Circular shift left by 1 bit
                2'b01: q <= {q[59:0], q[63:60]};   // Circular shift left by 4 bits
                2'b10: q <= {q[0], q[63:1]};       // Circular shift right by 1 bit
                2'b11: q <= {q[3:0], q[63:4]};     // Circular shift right by 4 bits
                default: q <= q;                   // No change
            endcase
        end
    end

endmodule