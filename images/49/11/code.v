module top_module(
    data,
    pad
);// GLOBAL PARAMETER DECLARATION
    parameter lpm_width = 1;
    parameter lpm_type = "lpm_outpad";
    parameter lpm_hint = "UNUSED";

// INPUT PORT DECLARATION
    input  [lpm_width-1:0] data;

// OUTPUT PORT DECLARATION   
    output [lpm_width-1:0] pad;

// INTERNAL REGISTER/SIGNAL DECLARATION
    reg    [lpm_width-1:0] pad;

// INITIAL CONSTRUCT BLOCK
    initial
    begin
        if (lpm_width <= 0)
        begin
            $display("Value of lpm_width parameter must be greater than 0(ERROR)");
            $display("Time: %0t  Instance: %m", $time);
            $finish;
        end
    end
    
// ALWAYS CONSTRUCT BLOCK
    always @(data)
    begin
        pad = data;
    end

endmodule