module top_module(
    input clk,
    input load,
    input up_down,
    output reg [2:0] out
);reg [2:0] reg1, reg2, reg3;

always @(posedge clk) begin
    if (load) begin
        reg1 <= 3'b0;
        reg2 <= 3'b0;
        reg3 <= 3'b0;
    end else begin
        if (up_down) begin
            reg1 <= reg2;
            reg2 <= reg3;
            reg3 <= reg3 + 1;
        end else begin
            reg1 <= reg2;
            reg2 <= reg3;
            reg3 <= reg3 - 1;
        end
    end
end

assign out = reg1;

endmodule