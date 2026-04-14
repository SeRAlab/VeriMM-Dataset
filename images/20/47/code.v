module PIPO_Shift_Register (
    input wire clk,
    input wire load,
    input wire oe, // output enable
    input wire [4:0] data_in,
    output reg [4:0] data_out
);
    
    reg [4:0] register;
    
    always @(posedge clk) begin
        if (load) begin
            register <= data_in; // Load data in parallel
        end
    end
    
    always @(*) begin
        if (oe) begin
            data_out = register; // Output data
        end else begin
            data_out = 5'b0; // Output zero if not enabled
        end
    end
endmodule