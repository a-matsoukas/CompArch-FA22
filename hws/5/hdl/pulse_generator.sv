/*
  Outputs a pulse generator with a period of "ticks".
  out should go high for one cycle ever "ticks" clocks.
*/
module pulse_generator(clk, rst, ena, ticks, out);

parameter N = 8;
input wire clk, rst, ena;
input wire [N-1:0] ticks;
output logic out;

logic [N-1:0] counter;
logic counter_comparator;
logic [N-1:0] counter_pp;
logic rst_counter;

always_comb begin
  counter_pp = counter + 1;
  counter_comparator = &(counter_pp ~^ ticks);
  rst_counter = rst | counter_comparator;
  out = counter_comparator;
end

always_ff @(posedge clk) begin
  if(rst_counter) begin
    counter <= 0;
  end else if(ena) begin
    counter <= counter_pp;
  end
end

endmodule
