module top_module(
    input [3:0] in_data,
    input in_enable,
    output reg [3:0] out_data,  // Changed to reg type
    output reg out_enable        // Changed to reg type
);reg [3:0] stored_data;

always @(*) begin
    if (in_enable) begin
        stored_data <= in_data;
        out_enable <= 1;
    end else begin
        out_enable <= 0;
    end
    out_data <= stored_data; // Move the assignment of out_data here
end

endmodule