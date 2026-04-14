module top_module(
    input CLK,
    input SHIFT,
    input LOAD,
    input [15:0] DATA_IN,
    input mode,
    output reg [15:0] DATA_OUT
);reg [15:0] reg1, reg2, reg3, reg4;

always @(posedge CLK) begin
    if (LOAD) begin
        reg1 <= DATA_IN;
        reg2 <= reg1;
        reg3 <= reg2;
        reg4 <= reg3;
    end else if (SHIFT) begin
        if (mode == 1'b0) begin
            reg1 <= {reg2[14:0], 1'b0};
            reg2 <= {reg3[14:0], 1'b0};
            reg3 <= {reg4[14:0], 1'b0};
            reg4 <= {DATA_OUT[14:0], 1'b0};
        end else begin
            reg1 <= {reg2[14:0], 1'b1};
            reg2 <= {reg3[14:0], 1'b1};
            reg3 <= {reg4[14:0], 1'b1};
            reg4 <= {DATA_OUT[14:0], 1'b1};
        end
    end
end

assign DATA_OUT = reg4;

endmodule