module gray_counter_12(
   input                clk,
   input                rst_n,
 
   output reg [11:0]    Q  
);
    reg [11:0] binary_counter;

    always @(posedge clk) begin
        if (!rst_n) binary_counter <= 12'b0;
        else binary_counter <= binary_counter + 1;
    end

    always @(*) begin
        Q = binary_counter ^ (binary_counter >> 1);
    end
endmodule