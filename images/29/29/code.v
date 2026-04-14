module RC_Oscillator (
    input wire clk,
    input wire rst,
    output reg out
);
    parameter COUNT_LIMIT = 20; // Set the frequency of the oscillator
    reg [4:0] count; // 5-bit counter

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            out <= 0;
        end else if (count < COUNT_LIMIT) begin
            count <= count + 1;
        end else begin
            count <= 0;
            out <= ~out; // Toggle output
        end
    end
endmodule