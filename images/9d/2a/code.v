module top_module(input logic in, output logic out);always @(posedge in) begin
        #10 out = !out;
    end

endmodule