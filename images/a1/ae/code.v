module top_module(
    input mesh_fifo_read,
    input fifo_read,
    input mesh_write_out,
    output reg mesh_access_out
);always @(*) begin
    if(mesh_fifo_read && !mesh_write_out) begin
        mesh_access_out <= 1'b1;
    end else begin
        mesh_access_out <= 1'b0;
    end
end

assign mesh_fifo_read = fifo_read;

endmodule