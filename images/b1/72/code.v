module top_module(input D,
     input LOAD,
     input CLK,
     output reg [5:0] Q);always @(posedge CLK) begin
        if (LOAD) begin
            Q <= {6{D}};
        end else begin
            Q <= {Q[4:0], D};
        end
    end

endmodule