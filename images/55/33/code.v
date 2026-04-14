module top_module(
    input wire clk,
    input wire din,
    output wire dout,
    input wire rst
);reg internReg = 1'b0;
    wire internReg_next;
    assign dout = internReg;
    always @(posedge clk) begin: assig_process_internReg
        if (rst == 1'b1)
            internReg <= 1'b0;
        else
            internReg <= internReg_next;
    end

    assign internReg_next = din;
endmodule