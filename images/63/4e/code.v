module top_module(A, B, sub_en, add_en, carry_in, out_en, data_out, carry_out);input [7:0] A, B;
    input sub_en, add_en, carry_in;
    output reg [7:0] data_out;
    output reg carry_out;
    output out_en;

    
    assign out_en = add_en | sub_en ? 1'b1 : 1'b0;

    
    always @(A, B, sub_en, add_en, carry_in) begin
        if (add_en)
            {carry_out, data_out} = A + B + carry_in;
        else if (sub_en)
            {carry_out, data_out} = A + (~B + 1);

    end 

endmodule