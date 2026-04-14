module top_module(
    input Clk, ShiftIn, reset, ShiftEn,
    output reg ShiftOut,
    output reg [3:0] ParallelOut
);reg [15:0] ShiftReg;
    integer i;
    
    always @(posedge Clk) begin
        if (reset) begin
            ShiftReg <= 16'h0000;
            ShiftOut <= 1'b0;
            ParallelOut <= 4'b0000;
        end
        else if (ShiftEn) begin
            ShiftReg <= {ShiftReg[14:0], ShiftIn};
            ShiftOut <= ShiftReg[15];

            // Using a combinatorial block to assign parallel output
            for (i = 0; i < 4; i = i + 1) begin
                ParallelOut[i] <= ShiftReg[4*i +: 4]; // Using "", here, ':=' limited to 4 bits from calculated index
            end
        end
    end
    
endmodule