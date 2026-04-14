module gray_code_counter(CLK, RST, Q);
input CLK, RST;
output reg [3:0] Q;

reg [3:0] bin_counter;

always @(posedge CLK or posedge RST) begin
    if (RST)
        bin_counter <= 4'b0000;
    else
        bin_counter <= bin_counter + 1'b1;
end

always @(bin_counter) begin
    Q = bin_counter ^ (bin_counter >> 1);
end

endmodule