module top_module(
                                input  wire clock,
                                input  wire pre_clear,
                                output wire reset_out
                              );parameter PIPE_DEPTH = 4;

    // Declare pipeline registers.
    reg [PIPE_DEPTH - 1 : 0]  ams_pipe;
    integer                   i;

    always @(posedge clock or negedge pre_clear)
    begin

        if (pre_clear == 1'b0)
        begin
            ams_pipe <= 0;
        end

        else
        begin
           for (i=0; i< PIPE_DEPTH; i = i + 1)
           begin
               if (i==0)
                   ams_pipe[i] <= 1'b1;
               else
                   ams_pipe[i] <= ams_pipe[i-1];
           end
        end // if-else

    end // always

    assign reset_out = ams_pipe[PIPE_DEPTH-1];

endmodule