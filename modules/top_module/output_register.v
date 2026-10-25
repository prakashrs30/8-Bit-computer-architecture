module output_register (
    input clk,
    input reset,
    input out_enable,
    input [7:0] bus_in,
    output reg [7:0] display_out
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            display_out <= 8'b00000000;
        else if (out_enable)
            display_out <= bus_in;
    end
endmodule
