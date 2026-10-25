module ram (
    input clk,
    input write_enable,
    input read_enable,
    input [3:0] ram_address,
    input [7:0] ram_inp,
    output [7:0] ram_out
);
    reg [7:0] memory [0:15];

    always @(posedge clk) begin
        if (write_enable)
            memory[ram_address] <= ram_inp;
    end

    assign ram_out = read_enable ? memory[ram_address] : 8'bz;
endmodule
