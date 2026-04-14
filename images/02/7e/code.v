module dynamic_range_compressor (
    input signed [3:0] in_data,
    output signed [3:0] out_data
);
    reg signed [3:0] compressed_data;

    always @(*) begin
        if (in_data < 4'b0010) begin // Below threshold, apply reduction
            compressed_data = in_data >> 1; // Compress by half
        end else if (in_data > 4'b0110) begin // Above threshold, apply gain
            compressed_data = in_data + 4'b0010; // Increase by 2
        end else begin
            compressed_data = in_data; // No change in range
        end
    end

    assign out_data = compressed_data;
endmodule