module nearest_neighbor_interpolation(
    input [7:0] address,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] data_array [0:15]; // 16 elements in the data array

    always @(*) begin
        // Initialize the data_array (for simulation purpose)
        data_array[0] = 8'd0;
        data_array[1] = 8'd1;
        data_array[2] = 8'd2;
        data_array[3] = 8'd3;
        data_array[4] = 8'd4;
        data_array[5] = 8'd5;
        data_array[6] = 8'd6;
        data_array[7] = 8'd7;
        data_array[8] = 8'd8;
        data_array[9] = 8'd9;
        data_array[10] = 8'd10;
        data_array[11] = 8'd11;
        data_array[12] = 8'd12;
        data_array[13] = 8'd13;
        data_array[14] = 8'd14;
        data_array[15] = 8'd15;

        if (address < 16) begin
            // Nearest neighbor logic
            data_out = data_array[address];
        end else begin
            data_out = 8'd0; // Default output for out of bounds
        end
    end
endmodule