module shift_register (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [31:0] data_in,
    output reg [31:0] data_out
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 32'b0;
        end else if (load) begin
            data_out <= data_in;
        end else begin
            data_out <= {data_out[30:0], 1'b0}; // Shift left
        end
    end
endmodule