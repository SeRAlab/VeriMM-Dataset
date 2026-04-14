module top_module(
    input [7:0] decode_vec,
    output reg [7:0] data1,
    output reg [7:0] data2
);// Set data1 and data2 to 0 by default
initial begin
    data1 = 8'h00;
    data2 = 8'h00;
end

// Check if bit 1 is set
always @(*) begin
    data1 = 8'h00;  // Reset data1 before checking
    if (decode_vec[1]) begin
        data1 = 8'h55;
    end
end

// Check if bit 2 is set
always @(*) begin
    data2 = 8'h00;  // Reset data2 before checking
    if (decode_vec[2]) begin
        data2 = 8'h55;
    end
end

// Monitor the input and output signals
initial begin
    $monitor("%h %h %h", decode_vec, data1, data2);
end

endmodule