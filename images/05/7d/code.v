module shift_register (
    input wire clk,
    input wire rst,
    input wire [1:0] data_in,
    output reg [1:0] data_out
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 2'b00;  // Asynchronous reset
        end else begin
            data_out <= {data_in[1], data_out[1]}; // Shift left and input new data
        end
    end
endmodule