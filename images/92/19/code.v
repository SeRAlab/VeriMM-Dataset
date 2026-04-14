module register_8bit (D, CLK, RESET, LOAD, Q);
input [7:0] D;
input CLK;
input RESET;
input LOAD;
output reg [7:0] Q;

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        Q <= 8'b00000000;
    end
    else if (LOAD) begin
        Q <= D;
    end
end

endmodule