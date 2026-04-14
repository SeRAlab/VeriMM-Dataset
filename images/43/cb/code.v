module lfsr_16bit (clk, rst, en, q);
   input clk, rst, en;
   output [15:0] q;
   
   reg [15:0] q;

always @(posedge clk or posedge rst) begin
    if (rst) 
    begin
        q <= 16'b0000000000000001;
    end 
    else if (en) 
    begin
        q <= {q[14:0], q[15] ^ q[13] ^ q[12] ^ q[10]};
    end
end

endmodule