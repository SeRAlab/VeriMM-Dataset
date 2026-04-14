module top_module(
    input CLK, reset, up, LOAD,
    input [7:0] DATA_IN,
    output Q7,
    output [7:0] Q
);reg [7:0] counter;
    reg [7:0] shift_reg;
    wire [7:0] and_output;

    // Up/Down Counter
    always @(posedge CLK) begin
        if (reset) begin
            counter <= 8'b0;
        end else begin
            if (up) begin
                counter <= counter + 1;
            end else begin
                counter <= counter - 1;
            end
        end
    end

    // Shift Register
    always @(posedge CLK) begin
        if (LOAD) begin
            shift_reg <= DATA_IN;
        end else begin
            shift_reg <= {shift_reg[6:0], 1'b0};
        end
    end

    // AND gate
    assign and_output = counter & shift_reg;

    // Outputs
    assign Q7 = and_output[7];
    assign Q = and_output;

endmodule