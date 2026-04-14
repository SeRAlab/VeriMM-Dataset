module fixed_priority_arbiter (
    input [4:0] req,
    output reg [4:0] grant
);
    always @(*) begin
        grant = 5'b00000; // Default no grant
        if (req[0]) grant = 5'b00001; // Grant for req[0]
        else if (req[1]) grant = 5'b00010; // Grant for req[1]
        else if (req[2]) grant = 5'b00100; // Grant for req[2]
        else if (req[3]) grant = 5'b01000; // Grant for req[3]
        else if (req[4]) grant = 5'b10000; // Grant for req[4]
    end
endmodule