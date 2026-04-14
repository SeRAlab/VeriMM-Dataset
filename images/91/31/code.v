module top_module( A, B, C, Y );input A, B, C;
output Y;
reg notifier;

assign Y = A & B;

specify
    (A => Y) = (0.0, 0.0);
    (B => Y) = (0.0, 0.0);
    (C => Y) = (0.0, 0.0);

	$setuphold(negedge A, negedge B, 0.0, 0.0, notifier);
	$setuphold(posedge A, posedge B, 0.0, 0.0, notifier);
	$setuphold(posedge A, posedge C, 0.0, 0.0, notifier);
	$setuphold(negedge C, negedge A, 0.0, 0.0, notifier);

endspecify

endmodule