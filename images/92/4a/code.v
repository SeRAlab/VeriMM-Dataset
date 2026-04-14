module top_module(
    input clk,
    input load,
    input [7:0] serial_in,
    input [7:0] data_in,
    input [4:0] shift_amount,
    output [7:0] shifted_value,
    output [7:0] functional_output
);reg [7:0] shift_reg;
    reg [7:0] shifted_reg;
    reg [4:0] shift_count;
    
    always @(posedge clk) begin
        if (load) begin
            shift_reg <= data_in;
            shift_count <= shift_amount;
        end else begin
            if (shift_count > 0) begin
                shifted_reg <= {shift_reg[6:0], serial_in};
                shift_reg <= shifted_reg;
                shift_count <= shift_count - 1;
            end else begin
                shifted_reg <= shift_reg;
            end
        end
    end
    
    assign shifted_value = shifted_reg;
    assign functional_output = shifted_reg + shift_reg;
    
endmodule