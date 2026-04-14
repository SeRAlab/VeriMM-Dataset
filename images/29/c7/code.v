module down_counter (
    input clk,
    input rst_n,
    input en,
    input [3:0] load_val,
    output reg [3:0] count
);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= load_val; // Load the initial value on reset
        end else if (en) begin
            if (count > 0) 
                count <= count - 1; // Decrement the counter
        end
    end
endmodule