module simple_DES (
    input wire [63:0] data_in,
    input wire [55:0] key,
    input wire clk,
    input wire rst,
    output reg [63:0] data_out
);
    
    reg [63:0] data_tmp;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 64'b0;
            data_tmp <= 64'b0;
        end else begin
            // Basic encryption logic (a simple example)
            data_tmp <= data_in ^ {key, 8'b0}; // Example operation
            data_out <= data_tmp; // Assigning the temporary data to output
        end
    end
endmodule