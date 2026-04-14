module loadable_counter (
    input clk,
    input reset,
    input load,
    input [3:0] data_in,
    output [3:0] count
);

    reg [3:0] counter_reg;  // 4-bit counter register

    always @(posedge clk) begin
        if (reset) begin
            counter_reg <= 4'b0000;  // Reset the counter to 0
        end else if (load) begin
            counter_reg <= data_in;  // Load the value into the counter
        end else begin
            counter_reg <= counter_reg + 1;  // Increment the counter
        end
    end

    assign count = counter_reg;

endmodule