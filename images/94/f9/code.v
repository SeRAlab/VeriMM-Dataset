module counter_with_clear (
    input               clk,
    input               clr,
    output reg [3:0]    count
);

    always @(posedge clk) begin
        if (clr) begin
            count <= 4'b0000;
        end else begin
            count <= count + 1;
        end
    end
    
endmodule