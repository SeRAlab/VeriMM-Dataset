module top_module(
    clk, reset, start,  
    a, b,               
    message             
);input               clk;
input               reset;
input               start;

input       [31:0]  a;
input       [31:0]  b;

output reg  [511:0] message;





always @(posedge clk, posedge reset) begin
    if (reset) begin
        message <= 512'b0;
    end else if (start) begin
        message <= {message[447:0], a, b};
    end
end

endmodule