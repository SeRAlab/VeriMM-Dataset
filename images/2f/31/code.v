module shift_register (
    input clk,
    input rst,
    input dir,
    input load,
    input [7:0] data_in,
    output reg [7:0] data_out
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_out <= 8'b0; // Reset the shift register
    end else if (load) begin
        data_out <= data_in; // Load the data in
    end else if (dir == 1'b0) begin
        data_out <= {data_out[6:0], 1'b0}; // Left shift
    end else begin
        data_out <= {1'b0, data_out[7:1]}; // Right shift
    end
end

endmodule