module binary_counter_2bit (
    input wire Clk,
    input wire En,
    input wire Rst,
    output reg [1:0] Q
    );

always @(posedge Clk) begin
    if (Rst)
        Q <= 2'b00;
    else if (En)
        Q <= Q + 1;
end

endmodule