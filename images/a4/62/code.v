module gray_counter(CLK, RST, Gray);
input CLK, RST;
output [1:0] Gray;
reg [1:0] Gray;
reg [1:0] binary_counter;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        binary_counter <= 0;
        Gray <= 0;
    end else begin
        binary_counter <= binary_counter + 1;
        Gray <= (binary_counter >> 1) ^ binary_counter;
    end
end

endmodule