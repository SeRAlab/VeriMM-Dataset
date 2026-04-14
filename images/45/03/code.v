module gray_code_counter(CLK, RST, Q);
input CLK, RST;
output [2:0] Q;
reg [2:0] Q;
reg [2:0] binary_counter;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        binary_counter <= 0;
        Q <= 0;
    end else begin
        binary_counter <= binary_counter + 1;
        Q <= (binary_counter >> 1) ^ binary_counter; // Convert binary to gray code
    end
end

endmodule