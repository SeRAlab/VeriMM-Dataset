module pattern_detector(
    input               clk             ,
    input               rst_n           ,
    input               data_in         ,
    input       [3:0]   pattern         ,

    output  reg         pattern_detected
);

    reg [3:0] shift_reg;

    // Shift register to store serial input data
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 0;
        end else begin
            shift_reg <= {shift_reg[2:0], data_in};
        end
    end

    // Pattern detection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pattern_detected <= 0;
        end else if (shift_reg == pattern) begin
            pattern_detected <= 1;
        end else begin
            pattern_detected <= 0;
        end
    end

endmodule