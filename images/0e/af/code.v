module shift_register (
    input wire clk,
    input wire reset,
    input wire [1:0] data_in,
    output reg [1:0] data_out
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 2'b00;
        end else begin
            data_out <= {data_out[0], data_in}; // Shift left
        end
    end
endmodule