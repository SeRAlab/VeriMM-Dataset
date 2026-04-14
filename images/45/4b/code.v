module top_module(datain, dataout);input  wire datain;
    output wire dataout;

    assign dataout = datain;

    specify
        (datain => dataout) = 0;
    endspecify

endmodule