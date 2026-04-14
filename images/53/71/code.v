module top_module(
    input clk,
    input areset,
    input load,
    input shift_right,
    input shift_enable,
    input [3:0] data_in,
    output [3:0] data_out,
    output full
);reg [3:0] reg1, reg2, reg3, reg4;

assign data_out = reg4;

always @(posedge clk or negedge areset) begin
    if (areset == 0) begin
        reg1 <= 4'b0;
        reg2 <= 4'b0;
        reg3 <= 4'b0;
        reg4 <= 4'b0;
    end
    else if (load) begin
        reg1 <= data_in;
        reg2 <= data_in;
        reg3 <= data_in;
        reg4 <= data_in;
    end
    else if (shift_enable) begin
        if (shift_right) begin
            reg1 <= data_in;
            reg2 <= reg1;
            reg3 <= reg2;
            reg4 <= reg3;
        end
        else begin
            reg4 <= reg3;
            reg3 <= reg2;
            reg2 <= reg1;
            reg1 <= data_in;
        end
    end
end

assign full = (reg1 != 4'b0) && (reg2 != 4'b0) && (reg3 != 4'b0) && (reg4 != 4'b0);

endmodule