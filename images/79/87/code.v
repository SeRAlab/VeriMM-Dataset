module shift_register(CLK,SEN,D,Q);
input CLK,SEN,D;
output [3:0] Q;
reg [3:0] Q;

always@(posedge CLK) begin
    if (SEN)
        Q <= {Q[2:0], D};
end

endmodule