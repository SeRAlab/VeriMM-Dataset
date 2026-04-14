module qam_mapper (
    input [3:0] in_data, // 4-bit input data
    output reg [7:0] qam_out // 8-bit output for QAM signal
);
    always @(*) begin
        case (in_data[3:2]) // I bits
            2'b00: qam_out[7:4] = 4'b0000; // I = 0
            2'b01: qam_out[7:4] = 4'b0100; // I = 1
            2'b10: qam_out[7:4] = 4'b1000; // I = 2
            2'b11: qam_out[7:4] = 4'b1100; // I = 3
            default: qam_out[7:4] = 4'b0000;
        endcase
        
        case (in_data[1:0]) // Q bits
            2'b00: qam_out[3:0] = 4'b0000; // Q = 0
            2'b01: qam_out[3:0] = 4'b0001; // Q = 1
            2'b10: qam_out[3:0] = 4'b0010; // Q = 2
            2'b11: qam_out[3:0] = 4'b0011; // Q = 3
            default: qam_out[3:0] = 4'b0000;
        endcase
        
        // Normalize the output to be in 2's complement format
        qam_out = qam_out - 8'b01111111; // Adjust to center around zero
    end
endmodule