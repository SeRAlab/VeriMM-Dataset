module top_module(
    input [4:0] BIN,
    output reg [3:0] BCD0,
    output reg [3:0] BCD1
);reg [4:0] temp_BIN; // Temporary variable to hold BIN value
reg [3:0] temp_bcd0;
reg [3:0] temp_bcd1;

always @(*) begin
    temp_BIN = BIN; // Store BIN value in temp variable
    temp_bcd0 = 0;
    temp_bcd1 = 0;

    if (temp_BIN >= 10) begin
        temp_bcd0 = temp_bcd0 + 1;
        temp_BIN = temp_BIN - 10;
    end
    if (temp_BIN >= 5) begin
        temp_bcd0 = temp_bcd0 + 8;
        temp_BIN = temp_BIN - 5;
    end
    if (temp_BIN >= 2) begin
        temp_bcd0 = temp_bcd0 + 4;
        temp_BIN = temp_BIN - 2;
    end
    if (temp_BIN >= 1) begin
        temp_bcd0 = temp_bcd0 + 2;
        temp_BIN = temp_BIN - 1;
    end

    if (temp_BIN >= 8) begin
        temp_bcd1 = temp_bcd1 + 1;
        temp_BIN = temp_BIN - 8;
    end
    if (temp_BIN >= 4) begin
        temp_bcd1 = temp_bcd1 + 8;
        temp_BIN = temp_BIN - 4;
    end
    if (temp_BIN >= 2) begin
        temp_bcd1 = temp_bcd1 + 4;
        temp_BIN = temp_BIN - 2;
    end
    if (temp_BIN >= 1) begin
        temp_bcd1 = temp_bcd1 + 2;
        temp_BIN = temp_BIN - 1;
    end

    BCD0 = temp_bcd0;
    BCD1 = temp_bcd1;
end

endmodule