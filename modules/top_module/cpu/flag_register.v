module flag_register (
    input clk,
    input reset,
    input flag_enable,
    input carry_in,
    input zero_in,
    output reg carry_flag,
    output reg zero_flag
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            carry_flag <= 1'b0;
            zero_flag  <= 1'b0;
        end
        else if (flag_enable) begin
            carry_flag <= carry_in;
            zero_flag  <= zero_in;
        end
    end
endmodule
