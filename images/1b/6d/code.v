module priority_arbiter (
    input wire [3:0] request,
    output reg [3:0] grant
);
    always @(*) begin
        grant = 4'b0000; // Default: no grant
        if (request[0]) grant = 4'b0001; // R0 granted
        else if (request[1]) grant = 4'b0010; // R1 granted
        else if (request[2]) grant = 4'b0100; // R2 granted
        else if (request[3]) grant = 4'b1000; // R3 granted
    end
endmodule