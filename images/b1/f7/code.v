module sync_down_counter_4(
   input                clk,
   input                rst_n,
   
   output reg [3:0]     Q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) Q <= 4'd15;
        else Q <= Q - 1'b1;
    end
endmodule