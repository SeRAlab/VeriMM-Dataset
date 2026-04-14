module top_module( input clk, input d, output reg [2:0] q );reg [2:0] temp;

always @(posedge clk) begin
    temp <= {temp[1:0], d};
end

assign q = {temp[2], temp[1], temp[0]};

endmodule