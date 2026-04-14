module top_module(datain, dataout);input  datain;
    output dataout;

    
    assign dataout = datain;

    
    
    specify
        (datain => dataout) = 0;
    endspecify

endmodule