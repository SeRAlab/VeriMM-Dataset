module binary_counter_2(
   input                clk,
   input                enable,
   input                rst_n,
 
   output reg [1:0]     count
);

    always @(posedge clk) begin
        if (!rst_n) count <= 2'b00;
        else if (enable) count <= count + 1;
    end

endmodule