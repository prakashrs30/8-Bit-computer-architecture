module register_b (
    input clk,
    input reset,
    input b_in,
    input [7:0] bus_in,
    output [7:0] b_val
);
    reg [7:0] b_reg;

    always @(posedge clk or posedge reset) begin
        if (reset)
            b_reg <= 8'b00000000;
        else if (b_in)
            b_reg <= bus_in;
    end

    assign b_val = b_reg;
endmodule
