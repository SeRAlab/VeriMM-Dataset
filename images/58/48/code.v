module top_module( input clk, input d, output q );reg [2:0] reg_array;
assign q = reg_array[0];

always @(posedge clk) begin
    reg_array <= {reg_array[1:0], d};
end

endmodule