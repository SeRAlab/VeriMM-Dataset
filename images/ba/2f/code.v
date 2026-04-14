module top_module(
    input clk,
    input reset,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [31:0] q
);reg [99:0] rotated_data;
reg [31:0] adder_out;

always @(posedge clk) begin
    if (reset) begin
        rotated_data <= 0;
        adder_out <= 0;
    end else begin
        if (load) begin
            if (ena == 2'b00) begin
                rotated_data <= data;
            end else if (ena == 2'b01) begin
                rotated_data <= {data[31:0], data[99:32]};
            end else if (ena == 2'b10) begin
                rotated_data <= {data[67:0], data[99:68]};
            end else begin
                rotated_data <= {data[33:0], data[99:34]};
            end
        end
        
        adder_out <= rotated_data[31:0] + 32'd12345678;
        q <= adder_out;
    end
end

endmodule