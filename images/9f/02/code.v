module top_module( 
    input clk,       // Add clk as an input
    input in, 
    output out 
);reg reg1, reg2, reg3;

always @(posedge clk) begin
    reg1 <= in;
end

always @(posedge clk) begin
    reg2 <= reg1;
end

always @(posedge clk) begin
    reg3 <= reg2;
end

assign out = reg3;

endmodule