module edge_detector (
    input clk,
    input sig,
    output reg edge
);
    reg sig_d;
    always @(posedge clk) begin
        edge <= sig & ~sig_d;
        sig_d <= sig;
    end
endmodule