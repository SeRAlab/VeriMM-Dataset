module top_module(
    input clk,
    input load,
    input select,
    input [3:0] data_in,
    output [3:0] q
);reg [3:0] shift_reg;
    reg [3:0] counter_reg;
    wire [3:0] sum;

    // Shift Register
    always @(posedge clk) begin
        if (load) begin
            shift_reg <= data_in;
        end else begin
            shift_reg <= {shift_reg[2:0], shift_reg[3]};
        end
    end

    // Counter
    always @(posedge clk) begin
        if (select) begin
            counter_reg <= counter_reg + 1;
        end
    end

    // Sum
    assign sum = shift_reg + counter_reg;

    // Output
    assign q = select ? counter_reg : shift_reg;

endmodule