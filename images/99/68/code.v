module Gray_code_counter(
   input                clk,
   input                rst_n,

   output reg [3:0]     Q
);
    reg [3:0] binary_counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            binary_counter <= 4'b0000;
            Q <= 4'b0000;
        end
        else begin
            binary_counter <= binary_counter + 1;
            Q <= binary_counter ^ (binary_counter >> 1);
        end
    end
endmodule