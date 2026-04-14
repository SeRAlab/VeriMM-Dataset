module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data1,
    input [99:0] data2,
    output reg [99:0] q
);reg [99:0] reg1;
reg [99:0] reg2;

always @(posedge clk) begin
    if(load) begin
        reg1 <= data1;
        reg2 <= data2;
    end else begin
        if(ena[0]) begin
            reg1 <= {reg1[0], reg1[99:1]};
            reg2 <= {reg2[0], reg2[99:1]};
        end
        if(ena[1]) begin
            reg1 <= {reg1[99], reg1[98:0]};
            reg2 <= {reg2[99], reg2[98:0]};
        end
    end
end

assign q = reg1 | reg2;

endmodule