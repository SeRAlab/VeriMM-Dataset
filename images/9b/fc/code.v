module shift_register_8(
   input                clk,
   input                rst_n,
   input                load,
   input  [7:0]         data_in,

   output reg [7:0]     Q
);
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) Q <= 8'b00000000;
        else if(load) Q <= data_in;
        else Q <= {1'b0, Q[7:1]};
    end
endmodule