module top_module(
    input [7:0] data_in,
    input [2:0] shift_amt,
    input direction,
    output reg [7:0] shifted_data // Change to reg type
);reg [7:0] shifted_out;
    
    always @(*) begin
        if (direction == 1'b0) begin // Left shift
            if (shift_amt == 3'b000) shifted_out = data_in;
            else if (shift_amt == 3'b001) shifted_out = {data_in[6:0], 1'b0};
            else if (shift_amt == 3'b010) shifted_out = {data_in[5:0], 2'b00};
            else if (shift_amt == 3'b011) shifted_out = {data_in[4:0], 3'b000};
            else if (shift_amt == 3'b100) shifted_out = {data_in[3:0], 4'b0000};
            else if (shift_amt == 3'b101) shifted_out = {data_in[2:0], 5'b00000};
            else if (shift_amt == 3'b110) shifted_out = {data_in[1:0], 6'b000000};
            else if (shift_amt == 3'b111) shifted_out = {data_in[0], 7'b0000000};
        end
        else begin // Right shift
            if (shift_amt == 3'b000) shifted_out = data_in;
            else if (shift_amt == 3'b001) shifted_out = {1'b0, data_in[7:1]};
            else if (shift_amt == 3'b010) shifted_out = {2'b00, data_in[7:2]};
            else if (shift_amt == 3'b011) shifted_out = {3'b000, data_in[7:3]};
            else if (shift_amt == 3'b100) shifted_out = {4'b0000, data_in[7:4]};
            else if (shift_amt == 3'b101) shifted_out = {5'b00000, data_in[7:5]};
            else if (shift_amt == 3'b110) shifted_out = {6'b000000, data_in[7:6]};
            else if (shift_amt == 3'b111) shifted_out = {7'b0000000, data_in[7]};
        end
        
        // Handle circular shifts
        if (direction == 1'b0) begin // Circular left shift
            shifted_data = {shifted_out[6:0], shifted_out[7]}; // Correct assignment
        end
        else begin // Circular right shift
            shifted_data = {shifted_out[0], shifted_out[7:1]}; // Correct assignment
        end
    end
    
endmodule