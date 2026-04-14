module top_module(
    output reg q, // Change q to output reg
    input d,
    input clk,
    input clrn,
    input prn,
    input ena,
    input asdata,
    input aload,
    input sclr,
    input sload
);parameter power_up = "dontcare"; 
    parameter is_wysiwyg = "false"; 

    always @(posedge clk) begin
        if (clrn == 1'b0) // Active-low clear
            q <= 1'b0;
        else if (prn == 1'b1) // Active-high preset
            q <= 1'b1;
        else if (ena)
            q <= d;
    end
endmodule