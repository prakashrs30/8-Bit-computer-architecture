module program_counter (
    input clk,
    input reset,
    input counter_enable,
    input counter_load,
    input counter_out_enable,
    input [3:0] data_in,
    output [7:0] bus_out,
    output wire [3:0] count_out
);
    reg [3:0] pc;

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 4'b0000;
        else if (counter_load)
            pc <= data_in;
        else if (counter_enable)
            pc <= pc + 4'b0001;
    end

    assign count_out = pc;
    assign bus_out = counter_out_enable ? {4'b0000, pc} : 8'bz;
endmodule
