module top_module(
    data,   // Data input to the XOR gates. (Required)
    result  // Result of XOR operators. (Required)
);// GLOBAL PARAMETER DECLARATION
    // Width of the data[] and result[] ports. Number of XOR gates. (Required)
    parameter lpm_width = 1;
    // Number of inputs to each XOR gate. Number of input buses. (Required)
    parameter lpm_size = 1;
    parameter lpm_type = "lpm_xor";
    parameter lpm_hint  = "UNUSED";

// INPUT PORT DECLARATION
    input  [(lpm_size * lpm_width)-1:0] data;

// OUTPUT PORT DECLARATION
    output [lpm_width-1:0] result;

// INTERNAL REGISTER/SIGNAL DECLARATION
    reg    [lpm_width-1:0] result_tmp;

// LOCAL INTEGER DECLARATION
    integer i;
    integer j;
    integer k;

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        if (lpm_width <= 0)
        begin
            $display("Value of lpm_width parameter must be greater than 0 (ERROR)");
            $display("Time: %0t  Instance: %m", $time);
            $finish;
        end

        if (lpm_size <= 0)
        begin
            $display("Value of lpm_size parameter must be greater than 0 (ERROR)");
            $display("Time: %0t  Instance: %m", $time);
            $finish;
        end
    end

// ALWAYS CONSTRUCT BLOCK
    always @(data)
    begin
        for (i=0; i<lpm_width; i=i+1)
        begin
            result_tmp[i] = 1'b0;
            for (j=0; j<lpm_size; j=j+1)
            begin
                k = (j * lpm_width) + i;
                result_tmp[i] = result_tmp[i] ^ data[k];
            end
        end
    end

// CONTINOUS ASSIGNMENT
    assign result = result_tmp;

endmodule