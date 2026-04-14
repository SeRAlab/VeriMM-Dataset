module johnson_counter_3(
   input                clk,
   input                rst,
   input                en,

   output reg [2:0]     Q
);
    always@(posedge clk) begin
        if(rst) Q <= 3'b000;
        else if(en) Q <= {~Q[2], Q[2:1]};
    end
endmodule