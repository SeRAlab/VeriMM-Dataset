module top_module(
  input D,
  input EN,
  output reg Q,       // Change to reg to store value in always block
  output reg Q_bar    // Change to reg to store value in always block
);// Define the behavior of the circuit using an always block
always @ (D, EN)
begin
  if (EN)
    begin
      Q <= D;
      Q_bar <= ~D; // This line can remain as is because Q is updated later
    end
end

// Implement the behavior of Q_bar based on Q
always @ (Q)
begin
  Q_bar <= ~Q; // Use Q to update Q_bar
end

endmodule