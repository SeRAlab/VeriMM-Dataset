module top_module(
    result
);output [11:0] result;
    parameter [11:0] lpm_cvalue = 12'b000000000000; // Define the default value for lpm_cvalue

    assign result = ~lpm_cvalue + 1'b1; // Two's complement

endmodule