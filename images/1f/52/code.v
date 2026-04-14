module audio_compressor (
    input [4:0] audio_in,
    output reg [7:0] compressed_out
);
    integer i;
    reg [1:0] run_length;
    reg bit_value;
    
    always @(*) begin
        run_length = 0;
        compressed_out = 8'b0;
        
        for (i = 0; i < 5; i = i + 1) begin
            if (i == 0 || audio_in[i] != audio_in[i-1]) begin
                if (run_length > 0) begin
                    compressed_out = {run_length[1:0], bit_value, compressed_out[7:2]};
                end
                run_length = 1;
                bit_value = audio_in[i];
            end else begin
                if (run_length < 3) begin
                    run_length = run_length + 1;
                end
            end
        end
        
        // Output the last run
        if (run_length > 0) begin
            compressed_out = {run_length[1:0], bit_value, compressed_out[7:2]};
        end
    end
endmodule