module LinkedListTraversal (
    input [3:0] index, // 4-bit input to access 16 entries
    output reg [7:0] value // 8-bit output for the value at the given index
);
    reg [7:0] list [0:15]; // A linked list represented as an array

    initial begin
        // Initialize the linked list with some values
        list[0] = 8'h01;
        list[1] = 8'h02;
        list[2] = 8'h03;
        list[3] = 8'h04;
        list[4] = 8'h05;
        list[5] = 8'h06;
        list[6] = 8'h07;
        list[7] = 8'h08;
        list[8] = 8'h09;
        list[9] = 8'h0A;
        list[10] = 8'h0B;
        list[11] = 8'h0C;
        list[12] = 8'h0D;
        list[13] = 8'h0E;
        list[14] = 8'h0F;
        list[15] = 8'h10;
    end

    always @(*) begin
        if (index < 16)
            value = list[index]; // Output the value at the index
        else
            value = 8'h00; // Output zero if index is out of bounds
    end
endmodule