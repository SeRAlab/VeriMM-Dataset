module priority_arbiter (
    input wire req0,
    input wire req1,
    input wire req2,
    input wire req3,
    output reg grant,
    output reg [1:0] grant_sel
);

always @(*) begin
    grant = 0;
    grant_sel = 2'b00; // Default

    if (req0) begin
        grant = 1;
        grant_sel = 2'b00;
    end else if (req1) begin
        grant = 1;
        grant_sel = 2'b01;
    end else if (req2) begin
        grant = 1;
        grant_sel = 2'b10;
    end else if (req3) begin
        grant = 1;
        grant_sel = 2'b11;
    end
end

endmodule