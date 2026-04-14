module priority_arbiter(
    input [3:0] req,
    output reg [3:0] grant
);
    always @(*) begin
        grant = 4'b0000; // Default to no grant
        if (req[0]) grant = 4'b0001; // Grant to req[0] if it's active
        else if (req[1]) grant = 4'b0010; // Grant to req[1] if req[0] is not active
        else if (req[2]) grant = 4'b0100; // Grant to req[2] if req[0] and req[1] are not active
        else if (req[3]) grant = 4'b1000; // Grant to req[3] if all higher priority are not active
    end
endmodule