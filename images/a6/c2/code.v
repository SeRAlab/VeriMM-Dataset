module down_counter_with_clear (
    input wire clk,
    input wire clr,
    output reg [9:0] count
);
    
    always @(posedge clk or posedge clr) begin
        if (clr) begin
            count <= 10'b0000000000;
        end else begin
            count <= count - 1;
        end
    end

endmodule