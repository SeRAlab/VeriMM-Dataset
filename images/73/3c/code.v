module shift_register(CLK, RST, Serial_in, Data_out);
input CLK, RST, Serial_in;
output [7:0] Data_out;
reg [7:0] Data_out;

always@(posedge CLK or posedge RST) begin
    if (RST)
        Data_out <= 0;
    else
        Data_out <= {Serial_in, Data_out[7:1]};
end

endmodule