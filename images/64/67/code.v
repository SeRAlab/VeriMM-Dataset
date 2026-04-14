module top_module( input clk, input d, output reg q );reg [2:0] reg_data;

always @(posedge clk) begin
    reg_data <= {reg_data[1:0], d};
end

assign q = reg_data[0];

endmodule