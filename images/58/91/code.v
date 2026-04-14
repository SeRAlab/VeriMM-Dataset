module top_module( 
    input wire [15:0] in,
    output wire [7:0] out_hi,
    output wire [7:0] out_lo );wire [1:0] select;

    // Assigning the select signal based on input
    assign select = {in[15], in[14]};  // Provide proper select input for two outputs

    // Multiplexer to select the output
    assign out_hi = (select == 2'b00) ? in[7:0] : 
                    (select == 2'b01) ? in[15:8] : 8'b0;  // Modify according to select logic
    assign out_lo = (select == 2'b00) ? in[7:0] : 
                    (select == 2'b01) ? in[15:8] : 8'b0;  // Modify according to select logic

endmodule