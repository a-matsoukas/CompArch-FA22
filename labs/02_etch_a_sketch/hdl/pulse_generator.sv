/*
  Outputs a pulse generator with a period of "ticks".
  out should go high for one cycle ever "ticks" clocks.
*/
module pulse_generator(clk, rst, ena, ticks, out);

parameter N = 8;
input wire clk, rst, ena;
input wire [N-1:0] ticks;
output logic out;

logic [N-1:0] counter, counter_next;
logic local_rst;

always_comb begin
  counter_next = counter + 1;
  out = counter == ticks;
  local_rst = rst | out;
end

always_ff @(posedge clk) begin : increment_counter
  if (local_rst) begin // since the counter starts at 0, subtract one from ticks
    counter <= 0;
  end
  else if (ena) begin
      counter <= counter_next;
  end
end


endmodule
