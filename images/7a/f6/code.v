module reg_with_load (
    input clk,
    input reset,
    input load,
    input [7:0] data_in,
    output [7:0] data_out
);

    reg [7:0] reg_data;  // 8-bit register

    always @(posedge clk) begin
        if (reset) begin
            reg_data <= 8'b00000000;  // Reset the register to 0
        end else if (load) begin
            reg_data <= data_in;  // Load data into the register
        end
    end

    assign data_out = reg_data;

endmodule