module top_module(CLK, RST, EN, Q);input CLK, RST, EN;
output [3:0] Q;
reg [3:0] Q;

always @(posedge CLK) begin
    if(RST) begin
        Q <= 4'b0;
    end
    else if(EN) begin
        Q <= Q + 1;
    end
end

endmodule