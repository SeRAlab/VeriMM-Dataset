module top_module(
    input clk,
    input load_en,
    input async_preset,
    input [7:0] d,
    output reg [7:0] q
);

    // Always block triggered on the rising edge of the clock or on async_preset
    always @(posedge clk or posedge async_preset) begin
        if (async_preset) begin
            q <= 8'b11111111;  // Asynchronous preset to all ones
        end else if (load_en) begin
            q <= d;  // Load the input data into the register
        end
    end

endmodule