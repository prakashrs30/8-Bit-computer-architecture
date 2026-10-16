module alu (
    input [7:0] A_in,
    input [7:0] B_in,
    input alu_out_en,
    input sub_en,
    input xor_en,
    input and_en,
    input or_en,
    output [7:0] bus_out,
    output carry_out,
    output zero_out
);
    reg [8:0] alu_result_ext;

    always @(*) begin
        if (sub_en)
            alu_result_ext = {1'b0, A_in} - {1'b0, B_in};
        else if (xor_en)
            alu_result_ext = {1'b0, A_in ^ B_in};
        else if (and_en)
            alu_result_ext = {1'b0, A_in & B_in};
        else if (or_en)
            alu_result_ext = {1'b0, A_in | B_in};
        else
            alu_result_ext = {1'b0, A_in} + {1'b0, B_in};
    end

    wire [7:0] alu_result = alu_result_ext[7:0];
    assign bus_out   = alu_out_en ? alu_result : 8'bz;
    assign carry_out = sub_en ? (A_in < B_in) : alu_result_ext[8];
    assign zero_out  = (alu_result == 8'b00000000);
endmodule
