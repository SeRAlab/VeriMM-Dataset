module top_module(
    input CLK,
    input LOAD,
    input [3:0] DATA,
    output reg [3:0] Q
);reg [3:0] reg1, reg2, reg3, reg4;

always @(posedge CLK) begin
    if (LOAD) begin
        reg1 <= DATA;
        reg2 <= DATA;
        reg3 <= DATA;
        reg4 <= DATA;
    end else begin
        reg1 <= reg2;
        reg2 <= reg3;
        reg3 <= reg4;
        reg4 <= Q;
    end
end

assign Q = LOAD ? DATA : reg1;

endmodule