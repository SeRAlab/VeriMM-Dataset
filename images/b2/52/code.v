module up_counter_with_clear_16bit (
    input wire clk,
    input wire clr,
    output reg [15:0] count
);
    
    always @(posedge clk or posedge clr) begin
        if (clr) begin
            count <= 16'b0000000000000000;
        end else begin
            count <= count + 1;
        end
    end

endmodule