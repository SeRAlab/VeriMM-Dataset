module top_module( clk, reset, enc_count, hall_count, fault );parameter ENCODER_COUNTER_WIDTH = ( 15 );
parameter HALL_COUNTER_WIDTH    = (  8 );


input clk, reset;
input signed [ENCODER_COUNTER_WIDTH-1:0] enc_count;
input signed [HALL_COUNTER_WIDTH-1:0] hall_count;
output reg fault = 0;


wire low_enc_count   = ( enc_count  < 2 ) & ( enc_count >  -2 );
wire high_hall_count = ( hall_count > 2 ) | ( hall_count < -2 );


always @( posedge clk ) begin : ENCODER_CHECKER
    if ( reset ) begin
        fault <= 0;
    end else begin
        if ( high_hall_count & low_enc_count ) begin
            fault <= 1;
        end
    end
end

endmodule