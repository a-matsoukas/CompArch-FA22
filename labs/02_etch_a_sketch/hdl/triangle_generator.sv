// Generates "triangle" waves (counts from 0 to 2^N-1, then back down again)
// The triangle should increment/decrement only if the ena signal is high, and hold its value otherwise.
module triangle_generator(clk, rst, ena, out);

parameter N = 8;
input wire clk, rst, ena;
output logic [N-1:0] out;

typedef enum logic {COUNTING_UP = 1'b0, COUNTING_DOWN =  1'b1} state_t;
state_t state, next_state;

logic counter_zero, counter_max;
logic [N-1:0] increment, out_next;


always_comb begin : state_comb
    counter_zero = ~|(out_next);
    counter_max = &(out_next);
    case (state)
        COUNTING_UP   : begin
            if (counter_max) begin
                next_state = COUNTING_DOWN;
            end 
            else begin
                next_state = COUNTING_UP;
            end
        end
        COUNTING_DOWN : begin
            if (counter_zero) begin
                next_state = COUNTING_UP;
            end
            else begin
                next_state = COUNTING_DOWN;
            end
        end
    endcase
end

always_comb begin : counter_comb
    case (state)
        COUNTING_UP   : increment = 1;
        COUNTING_DOWN : increment = -1;
    endcase
    out_next = out + increment;
end

always_ff @(posedge clk) begin : counter
    if (rst) begin
        out <= 0;
    end
    else if (ena) begin
        out <= out_next;
    end    
end

always_ff @(posedge clk) begin : state_machine
    if (rst) begin
        state <= COUNTING_UP;
    end 
    else begin
        state <= next_state;
    end
end


endmodule