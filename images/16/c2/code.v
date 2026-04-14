module priority_arbiter (
    input [3:0] req,
    output reg [3:0] grant
);
    always @(*) begin
        grant = 4'b0000; // Default: no grant
        casez (req) // Using casez for priority handling
            4'b1???: grant = 4'b0001; // Grant to input 0
            4'b01??: grant = 4'b0010; // Grant to input 1
            4'b001?: grant = 4'b0100; // Grant to input 2
            4'b0001: grant = 4'b1000; // Grant to input 3
            default: grant = 4'b0000; // No grant
        endcase
    end
endmodule