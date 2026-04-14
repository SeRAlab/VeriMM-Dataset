module top_module(
    input [3:0] in,
    output reg [1:0] pos,
    output reg valid
);

    // Always block to determine the highest-order '1' bit position
    always @(*) begin
        casez (in)
            4'b1???: pos = 2'b11;
            4'b01??: pos = 2'b10;
            4'b001?: pos = 2'b01;
            4'b0001: pos = 2'b00;
            default: pos = 2'b00;
        endcase
        
        valid = |in; // Valid is high if any '1' bit is present
    end

endmodule