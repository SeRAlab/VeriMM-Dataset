module down_counter (
    input clk,
    input rst,
    input load,
    input [4:0] load_val,
    output reg [4:0] count
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 5'b00000; // Reset count to 0
        end else if (load) begin
            count <= load_val; // Load value
        end else if (count > 0) begin
            count <= count - 1; // Decrement count
        end
    end
    
endmodule