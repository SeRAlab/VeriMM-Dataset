module top_module(
   output reg [31:0] Q,
   input CLK,
   input CEN,
   input WEN,
   input [9:0] A,
   input [31:0] D
);// Define the RAM memory
    reg [31:0] ram [0:1023];

    always @(posedge CLK) begin
        if (!CEN) begin
            if (!WEN) begin
                ram[A] <= D;      // Write data to RAM
            end
            Q <= ram[A];          // Read data from RAM
        end
    end

endmodule