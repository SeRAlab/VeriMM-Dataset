module priority_arbiter (
    input wire R0,
    input wire R1,
    input wire R2,
    input wire R3,
    output reg [1:0] grant
);

always @(*) begin
    if (R0) begin
        grant = 2'b00; // R0 is granted
    end else if (R1) begin
        grant = 2'b01; // R1 is granted
    end else if (R2) begin
        grant = 2'b10; // R2 is granted
    end else if (R3) begin
        grant = 2'b11; // R3 is granted
    end else begin
        grant = 2'bxx; // No request
    end
end

endmodule