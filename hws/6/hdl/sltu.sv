module sltu(a, b, out);
parameter N = 32;
input wire signed [N-1:0] a, b;
output logic out;

// Using only *structural* combinational logic, make a module that computes if a is less than b!
// Note: this assumes that the two inputs are signed: aka should be interpreted as two's complement.

// Copy any other modules you use into this folder and update the Makefile accordingly.
logic [N:0] sum;
logic c_out;

adder_n #(.N(N+1)) adder_33bit({1'b0, a},{1'b1, ~b},1'b1,sum,c_out);

always_comb out = sum[N]; //(~c_out & sum[31]) | (a[31] & ~b[31]);


endmodule


