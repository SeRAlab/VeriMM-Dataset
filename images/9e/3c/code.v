module top_module(
    input clk,
    input reset,
    input [31:0] in,
    output reg [3:0] count
);reg [31:0] in_reg;
    reg [3:0] count_reg;
    wire rising_edge;

    // Register the input signal
    always @(posedge clk) begin
        in_reg <= in;
    end

    // Detect a rising edge in the input signal
    assign rising_edge = (in_reg[31] == 1'b0) && (in_reg[30:0] == 31'b111_1111_1111_1111_1111_1111_1111_1111);

    // Counter logic
    always @(posedge clk) begin
        if (reset) begin
            count_reg <= 4'b0;
        end else if (rising_edge) begin
            if (count_reg == 4'b1111) begin
                count_reg <= 4'b0;
            end else begin
                count_reg <= count_reg + 1;
            end
        end
    end

    // Synchronous reset logic
    always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0;
        end else begin
            count <= count_reg;
        end
    end

endmodule