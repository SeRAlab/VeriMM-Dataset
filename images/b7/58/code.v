module top_module(clk, clk_out);input clk;
output reg clk_out;
reg rst;

// Calculate the value of n
parameter Ts = 80;
parameter Te = 20;
parameter n = ((Ts / (2 * Te)) - 1);

// Determine the number of bits needed to represent n in binary
parameter bitCount = $clog2(n + 1); // Changed to remove -1

// Counter to keep track of the number of input clock cycles
reg [bitCount-1:0] counter; // Changed to use bitCount-1

initial
begin
    rst = 0;
end

always @(posedge clk or negedge rst)
begin
    if (!rst)
    begin
        // Reset the counter and output clock signal
        rst <= 1;
        counter <= {bitCount{1'b0}};
        clk_out <= 1'b0;
    end
    else
    begin
        // Increment the counter
        counter <= counter + 1;

        // If the counter reaches n, toggle the output clock signal
        if (counter == n)
        begin
            counter <= {bitCount{1'b0}};
            clk_out <= ~clk_out;
        end
    end
end

endmodule