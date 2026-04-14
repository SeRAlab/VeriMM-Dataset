module binary_search (
    input wire [2:0] index,
    input wire write_enable,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory [7:0]; // 8 entries of 8-bit memory

    initial begin
        memory[0] = 8'h01;
        memory[1] = 8'h02;
        memory[2] = 8'h03;
        memory[3] = 8'h04;
        memory[4] = 8'h05;
        memory[5] = 8'h06;
        memory[6] = 8'h07;
        memory[7] = 8'h08;
    end

    always @(*) begin
        if (write_enable) begin
            memory[index] = data_in; // Write new data to memory
            data_out = 8'bz; // Output is high impedance during write
        end else begin
            data_out = memory[index]; // Read data from memory
        end
    end
endmodule