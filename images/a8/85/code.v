module top_module(
    input Up,
    input Down,
    input Clk,
    input reset,
    output reg [3:0] Count,
    output reg [3:0] BCD1,
    output reg [3:0] BCD0,
    output reg [7:0] BCD_output
);reg [3:0] BCD_count;

// Up/Down Counter
always @(posedge Clk or posedge reset) begin
    if (reset) begin
        Count <= 4'b0000;
    end else if (Up) begin
        Count <= Count + 1;
    end else if (Down) begin
        Count <= Count - 1;
    end
end

// Binary to BCD Converter
always @(Count) begin
    case (Count)
        4'b0000: begin
            BCD_count = 4'b0000;
        end
        4'b0001: begin
            BCD_count = 4'b0001;
        end
        4'b0010: begin
            BCD_count = 4'b0010;
        end
        4'b0011: begin
            BCD_count = 4'b0011;
        end
        4'b0100: begin
            BCD_count = 4'b0100;
        end
        4'b0101: begin
            BCD_count = 4'b0101;
        end
        4'b0110: begin
            BCD_count = 4'b0110;
        end
        4'b0111: begin
            BCD_count = 4'b0111;
        end
        4'b1000: begin
            BCD_count = 4'b1000;
        end
        4'b1001: begin
            BCD_count = 4'b1001;
        end
        4'b1010: begin
            BCD_count = 4'b0001;
            BCD1 = 4'b0001;
        end
        4'b1011: begin
            BCD_count = 4'b0001;
            BCD1 = 4'b0001;
            BCD0 = 4'b0001;
        end
        4'b1100: begin
            BCD_count = 4'b0001;
            BCD0 = 4'b0001;
        end
        4'b1101: begin
            BCD_count = 4'b0010;
        end
        4'b1110: begin
            BCD_count = 4'b0011;
        end
        4'b1111: begin
            BCD_count = 4'b0100;
        end
    endcase
end

// BCD Output
always @(BCD1, BCD0) begin
    BCD_output = {BCD1, BCD0, BCD_count};
end

endmodule