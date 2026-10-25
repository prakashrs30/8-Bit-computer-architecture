module mar (
    input clk,
    input reset,
    input mar_in,
    input [3:0] bus_in,
    output reg [3:0] address_out
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            address_out <= 4'b0000;
        else if (mar_in)
            address_out <= bus_in;
    end
endmodule
