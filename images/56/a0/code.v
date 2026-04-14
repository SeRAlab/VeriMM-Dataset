module shift_register_8bit(CLK, LOAD, DATA_IN, DATA_OUT);
input CLK;
input LOAD;
input [7:0] DATA_IN;
output reg [7:0] DATA_OUT;

always @(posedge CLK) begin
    if (LOAD) begin
        DATA_OUT <= DATA_IN;
    end else begin
        DATA_OUT <= DATA_OUT >> 1;
    end
end

endmodule