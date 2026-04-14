module top_module(
    input clk,
    input load,
    input [7:0] data_in,
    output [7:0] data_out
);reg [7:0] shift_reg;
    
    always @(posedge clk) begin
        if (load) begin
            shift_reg <= data_in;
        end else begin
            shift_reg <= {shift_reg[6:0], shift_reg[7]};
        end
    end
    
    assign data_out = shift_reg;
    
endmodule