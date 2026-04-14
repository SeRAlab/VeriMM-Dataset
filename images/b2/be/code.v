module top_module(
    input [8:0] rgb_bullet,
    input [8:0] default_color,
    input [4:0] hit_times,
    input is_hit,
    output [8:0] rgb_out
    );wire is_dead;
    
assign is_dead = (hit_times==5'd4)? 1:0;    
assign rgb_out = (is_hit && is_dead)? default_color:rgb_bullet;

endmodule