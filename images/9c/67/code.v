module top_module(output reg sig_out, input clock, reset, sig_in);reg [3:0] Q;
    wire J, K;

    assign J = &Q[3:1],
           K = ~(|Q[3:1]);

    always @(posedge clock) begin
        if(~reset)
            Q <= 4'b0;
        else begin
            Q[3:1] <= Q[2:0];
            Q[0] <= sig_in; 
        end
    end

    always @(posedge clock) begin
        if(~reset)
            sig_out <= 1'b0;
        else begin
            case({J, K})
                2'b01: sig_out <= 1'b0;
                2'b10: sig_out <= 1'b1;
                2'b11: sig_out <= ~sig_out;
                default: ; 
            endcase
        end
    end
    
endmodule