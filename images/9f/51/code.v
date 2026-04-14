module top_module(
    input [4:0] ctrl,
    input [15:0] data_in_A,
    input [15:0] data_in_B,
    output reg [15:0] data_out
);// Addition
always @(ctrl, data_in_A, data_in_B) begin
    if (ctrl == 1) begin
        data_out <= data_in_A + data_in_B;
    end
end

// Subtraction
always @(ctrl, data_in_A, data_in_B) begin
    if (ctrl == 2) begin
        data_out <= data_in_A - data_in_B;
    end
end

// Multiplication
always @(ctrl, data_in_A, data_in_B) begin
    if (ctrl == 3) begin
        data_out <= data_in_A * data_in_B;
    end
end

// Division
always @(ctrl, data_in_A, data_in_B) begin
    if (ctrl == 4) begin
        data_out <= data_in_A / data_in_B;
    end
end

// Bitwise AND
always @(ctrl, data_in_A, data_in_B) begin
    if (ctrl == 5) begin
        data_out <= data_in_A & data_in_B;
    end
end

// Bitwise OR
always @(ctrl, data_in_A, data_in_B) begin
    if (ctrl == 6) begin
        data_out <= data_in_A | data_in_B;
    end
end

// Bitwise XOR
always @(ctrl, data_in_A, data_in_B) begin
    if (ctrl == 7) begin
        data_out <= data_in_A ^ data_in_B;
    end
end

// Bitwise complement
always @(ctrl, data_in_A) begin
    if (ctrl == 8) begin
        data_out <= ~data_in_A;
    end
end

// Left shift
always @(ctrl, data_in_A, data_in_B) begin
    if (ctrl == 9) begin
        data_out <= data_in_A << data_in_B[3:0];
    end
end

// Right shift
always @(ctrl, data_in_A, data_in_B) begin
    if (ctrl == 10) begin
        data_out <= data_in_A >> data_in_B[3:0];
    end
end

// Logical shift left
always @(ctrl, data_in_A, data_in_B) begin
    if (ctrl == 11) begin
        data_out <= data_in_A <<< data_in_B[3:0];
    end
end

// Logical shift right
always @(ctrl, data_in_A, data_in_B) begin
    if (ctrl == 12) begin
        data_out <= data_in_A >>> data_in_B[3:0];
    end
end

endmodule