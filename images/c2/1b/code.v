module and_gate(clk, rst, a, b, out);
    input clk, rst, a, b;
    output reg out;

    always @(posedge clk or negedge rst) begin
        if(rst == 0) begin
            out <= 0;
        end else begin
            out <= a & b;
        end
    end
endmodule