module top_module(
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    input [7:0] in,
    output reg [3:0] final_output
);// 2-to-1 multiplexer
    always @(*)
    begin
        case({sel_b2, sel_b1})
            2'b00: final_output[1:0] = {1'b0, a}; // Extend a to 2 bits
            2'b01: final_output[1:0] = {1'b0, a}; // Extend a to 2 bits
            2'b10: final_output[1:0] = {1'b0, b}; // Extend b to 2 bits
            2'b11: final_output[1:0] = {1'b0, b}; // Extend b to 2 bits
        endcase
    end

    // Priority encoder
    always @(*)
    begin
        if (in[0] == 1) final_output[3:2] = 2'b00;
        else if (in[1] == 1) final_output[3:2] = 2'b01;
        else if (in[2] == 1) final_output[3:2] = 2'b10;
        else if (in[3] == 1) final_output[3:2] = 2'b11;
        else if (in[4] == 1) final_output[3:2] = 2'b00; // Fixed assigning 2 bits
        else if (in[5] == 1) final_output[3:2] = 2'b01; // Fixed assigning 2 bits
        else if (in[6] == 1) final_output[3:2] = 2'b10; // Fixed assigning 2 bits
        else if (in[7] == 1) final_output[3:2] = 2'b11; // Fixed assigning 2 bits
        else final_output[3:2] = 2'b00;
    end

endmodule