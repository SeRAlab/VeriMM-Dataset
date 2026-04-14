module top_module(
        input   wire[1:0] count_i,
        input   wire      op,
        output  reg[1:0]  count
    );always @ (*)
    begin
        case (count_i)
            
            
            2'b00:  count = (op) ? count_i          : count_i + 2'b1;
            2'b01:  count = (op) ? count_i - 2'b1   : count_i + 2'b1;
            2'b10:  count = (op) ? count_i + 2'b1   : count_i - 2'b1;
            2'b11:  count = (op) ? count_i          : count_i - 2'b1;
            default count = 2'b0;
        endcase
    end

endmodule