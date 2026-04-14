module priority_arbiter (
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg grant,
    output reg [1:0] grant_index
);

always @(*) begin
    if (req0) begin
        grant = 1;
        grant_index = 2'b00;
    end else if (req1) begin
        grant = 1;
        grant_index = 2'b01;
    end else if (req2) begin
        grant = 1;
        grant_index = 2'b10;
    end else if (req3) begin
        grant = 1;
        grant_index = 2'b11;
    end else begin
        grant = 0;
        grant_index = 2'bxx; // Indeterminate if no req is high
    end
end

endmodule