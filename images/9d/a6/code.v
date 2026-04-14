module top_module(
    input [3:0] I,
    input [1:0] S,
    output O,
    output OB
);// Assuming IOBUFDS_DIFF_OUT is a differential output buffer that should be defined or replaced
    // If the specific differential I/O output buffer is not available, we can use a simpler output assignment.
    wire O_temp; // Temporary wire for the output

    // 4:1 MUX implementation
    assign O_temp = (S[1] & S[0]) ? I[3] :
                    (S[1] & ~S[0]) ? I[2] :
                    (~S[1] & S[0]) ? I[1] :
                    (~S[1] & ~S[0]) ? I[0] :
                    1'bz;
    assign O = O_temp; // Assigning the temporary wire to output O
    assign OB = ~O; // Complement for the differential output

endmodule