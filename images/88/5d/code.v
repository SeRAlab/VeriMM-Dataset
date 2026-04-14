module top_module(
    input clk,
    input load,
    input ena,
    input clr,
    input [1:0] amount,
    input [31:0] data,
    output reg [31:0] q);

    always @(posedge clk) begin
        if (clr) begin
            q <= 32'b0;
        end else if (load) begin
            q <= data;
        end else if (ena) begin
            case (amount)
                2'b00: q <= {q[30:0], q[31]};       // Circular shift left by 1 bit
                2'b01: q <= {q[27:0], q[31:28]};    // Circular shift left by 4 bits
                2'b10: q <= {q[0], q[31:1]};        // Circular shift right by 1 bit
                2'b11: q <= {q[3:0], q[31:4]};      // Circular shift right by 4 bits
                default: q <= q;                    // No change
            endcase
        end
    end

endmodule