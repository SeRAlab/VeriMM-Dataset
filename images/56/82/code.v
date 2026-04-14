module top_module(enable_pts, reset_pts, clk_SD, signal_in, signal_out, parallel_complete);output reg signal_out, parallel_complete;
    input wire [39:0]signal_in;
    input wire clk_SD;
    input wire reset_pts, enable_pts;
    reg [8:0]contador = 0;
    always @ ( posedge clk_SD ) begin
        if (reset_pts == 1) begin
            signal_out <= 0;
            contador <= 0;
            parallel_complete <= 0;
        end else begin
            if (enable_pts == 1) begin
                if (contador == 40) begin
                    parallel_complete <= 1;
                    contador <= 0;
                end else begin
                    parallel_complete <= 0;
                    signal_out = signal_in[39 - contador];
                    contador <= contador + 1;
                end
            end else begin
                signal_out <= 0;
            end
        end
    end
endmodule