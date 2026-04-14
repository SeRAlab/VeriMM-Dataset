module top_module(
    input A1,
    input A2,
    input A3,
    input B1,
    input B2,
    output Y
);// Local signals
    wire nand0_out;
    wire nand1_out;
    wire and0_out_Y;

    //   Name   Output      Other arguments
    nand nand0 (nand0_out , A2, A1, A3          );
    nand nand1 (nand1_out , B1, B2              );
    nand nand2 (and0_out_Y, A3, nand1_out       );
    and  and0  (Y         , nand0_out, and0_out_Y);

endmodule