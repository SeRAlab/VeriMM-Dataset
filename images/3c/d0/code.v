module priority_encoder (
    input [3:0] in,
    output reg [1:0] out
);
    always @* begin
        casez (in)
            4'b1??? : out = 2'b11; // A is active
            4'b01?? : out = 2'b10; // B is active
            4'b001? : out = 2'b01; // C is active
            4'b0001 : out = 2'b00; // D is active
            default : out = 2'b00; // No active inputs
        endcase
    end
endmodule