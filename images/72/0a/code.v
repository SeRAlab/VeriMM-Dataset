module top_module( input clk, input d, output q );reg [2:0] buffer;

always @(posedge clk)
begin
    buffer <= {buffer[1:0], d};
end

assign q = buffer[2];

endmodule