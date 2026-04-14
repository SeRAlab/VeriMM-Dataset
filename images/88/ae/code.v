module top_module(
    input clk,
    input [2:0] parallel_load,
    input shift,
    input control,
    output reg [2:0] out
);reg [2:0] reg1, reg2, reg3;

always @(posedge clk) begin
    if (control == 1'b0) begin
        reg1 <= parallel_load;
        reg2 <= reg1;
        reg3 <= reg2;
    end else begin
        reg3 <= reg2;
        reg2 <= reg1;
        reg1 <= parallel_load;
    end
end

always @(*) begin
    if (shift == 1'b1) begin
        if (control == 1'b0) begin
            out = {reg3, reg2[2]};
        end else begin
            out = {reg1[0], reg3[2:1]};
        end
    end else begin
        out = reg1;
    end
end

endmodule