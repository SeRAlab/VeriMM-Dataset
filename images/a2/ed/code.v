module ShiftRegister8Bit (
    input clk,
    input reset,
    input load,
    input [7:0] data,
    output reg [7:0] q
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 8'b00000000;
        else if (load)
            q <= data;
        else
            q <= q << 1;
    end
endmodule