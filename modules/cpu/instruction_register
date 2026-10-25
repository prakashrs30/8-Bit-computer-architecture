module instruction_register (
    input clk,
    input reset,
    input ir_in,
    input ir_out,
    input [7:0] bus_in,
    output [3:0] opcode,
    output [7:0] bus_out
);
    reg [7:0] ir;

    always @(posedge clk or posedge reset) begin
        if (reset)
            ir <= 8'b00000000;
        else if (ir_in)
            ir <= bus_in;
    end

    assign opcode  = ir[7:4];
    assign bus_out = ir_out ? {4'b0000, ir[3:0]} : 8'bz;
endmodule
