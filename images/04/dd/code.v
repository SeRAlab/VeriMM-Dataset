module PIPO_Shift_Register (
    input [4:0] data_in,
    input load,
    input enable,
    input clk,
    output reg [4:0] data_out
);
    
    reg [4:0] register;

    always @(posedge clk) begin
        if (load) begin
            register <= data_in;  // Load data
        end
        if (enable) begin
            data_out <= register;  // Output data
        end
    end

endmodule