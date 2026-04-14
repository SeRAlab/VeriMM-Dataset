module up_counter_with_clear_4bit (
    input wire clk,
    input wire clr,
    output reg [3:0] count
);
    
    always @(posedge clk or posedge clr) begin
        if (clr) begin
            count <= 4'b0000;
        end else begin
            count <= count + 1;
        end
    end

endmodule