// Generates "triangle" waves (counts from 0 to 2^N-1, then back down again)
// The triangle should increment/decrement only if the ena signal is high, and hold its value otherwise.
module triangle_generator(clk, rst, ena, out);

parameter N = 8;
input wire clk, rst, ena;
output logic [N-1:0] out;

typedef enum logic {COUNTING_UP = 1'b1, COUNTING_DOWN = 1'b0} state_t;
state_t state, next_state;

logic [N-1:0] adder_a, counter_pp;

always_comb begin : cl_for_counter
  case(state)
    COUNTING_DOWN : adder_a = -1;
    COUNTING_UP   : adder_a = 1;
    default       : adder_a = 0; // Not implemented
  endcase
  counter_pp = out + adder_a;
end

always_ff @(posedge clk) begin : counter_register
  if (rst) out <= 0;
  else if(ena) out <= counter_pp;  
end

logic counter_is_zero, counter_is_max;
always_comb begin : finite_state_machine_comb
  counter_is_zero = (counter_pp == 0);
  counter_is_max  = (counter_pp == {N{1'b1}});
  case(state)
    COUNTING_DOWN: begin
      if(counter_is_zero) next_state = COUNTING_UP;
      else next_state = state;
    end
    COUNTING_UP  : begin
      if(counter_is_max) next_state = COUNTING_DOWN;
      else next_state = state;
    end
  endcase
  end

always_ff @(posedge clk) begin : finite_state_machine_ff
  if(rst) state <= COUNTING_UP;
  else state <= next_state;
end

endmodule