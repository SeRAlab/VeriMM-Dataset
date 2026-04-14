module PIPO_Shift_Register #(parameter WIDTH = 8) (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [WIDTH-1:0] parallel_data,
    output reg [WIDTH-1:0] parallel_out
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            parallel_out <= 0;
        end else if (load) begin
            parallel_out <= parallel_data;
        end 
    end

endmodule