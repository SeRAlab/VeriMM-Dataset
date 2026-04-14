module top_module(
    input CLK,
    input PL1,
    input CLR1,
    input PL2,
    input EN2,
    input [3:0] D1,
    input [3:0] D2,
    output reg [7:0] Q
);reg [3:0] reg1;
reg [3:0] reg2;

always @(posedge CLK) begin
    if (CLR1) begin
        reg1 <= 4'b0;
    end else if (PL1) begin
        reg1 <= D1;
    end else begin
        reg1 <= {reg1[2:0], reg1[3]};
    end
end

always @(negedge CLK) begin
    if (EN2) begin
        reg2 <= {reg2[2:0], D2};
    end
end

assign Q = {reg1, reg2} | 8'b0;

endmodule