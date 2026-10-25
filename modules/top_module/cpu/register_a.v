module register_a (
    input clk,
    input reset,
    input a_in,
    input a_out,
    input [7:0] bus_in,
    output [7:0] a_val,
    output [7:0] bus_out
);
    reg [7:0] a_reg;

    always @(posedge clk or posedge reset) begin
        if (reset)
            a_reg <= 8'b00000000;
        else if (a_in)
            a_reg <= bus_in;
    end

    assign a_val   = a_reg;
    assign bus_out = a_out ? a_reg : 8'bz;
endmodule
