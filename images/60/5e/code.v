module top_module(
    input [7:0] D,
    output reg P
);integer i;
reg [7:0] temp;

always @(*) begin
    temp = D;
    for(i=0; i<8; i=i+1) begin
        temp = temp >> 1;
        if(D[i]) P = ~P;
    end
end

endmodule