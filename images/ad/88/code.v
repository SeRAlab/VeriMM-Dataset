module top_module(CLK, RST, LOAD, EN, DATA_IN, DATA_OUT);input CLK, RST, LOAD, EN;
input [3:0] DATA_IN;
output reg [3:0] DATA_OUT;

always @(posedge CLK) begin
    if (RST) begin
        DATA_OUT <= 4'b0;
    end else if (LOAD) begin
        DATA_OUT <= DATA_IN;
    end else if (EN) begin
        if (DATA_OUT == 4'b1111) begin
            DATA_OUT <= 4'b0;
        end else begin
            DATA_OUT <= DATA_OUT + 1;
        end
    end
end

endmodule