module top_module(
    input clk,
    input reset,
    input [2:0] in,
    input load,
    input [1:0] select,
    input [99:0] data,
    output reg [2:0] out
);reg [2:0] shift_reg;
reg [99:0] loaded_data;

always @(posedge clk) begin
    if (reset) begin
        shift_reg <= 3'b0;
        loaded_data <= 100'b0;
    end else if (load) begin
        loaded_data <= data; // Load data first before assigning to shift_reg
        shift_reg <= loaded_data[99:97]; // Assign shifted bits after loading
    end else begin
        if (select == 2'b00) begin // no rotation
            shift_reg <= in;
        end else if (select == 2'b01) begin // right rotation
            shift_reg <= {in[0], in[2:1]};
        end else if (select == 2'b10) begin // left rotation
            shift_reg <= {in[1:0], in[2]}; // Corrected order for left rotation
        end
    end
end

assign out = shift_reg;

endmodule