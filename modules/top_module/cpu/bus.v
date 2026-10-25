module bus (
    input [7:0] pc_data,
    input [7:0] ram_data,
    input [7:0] ir_data,
    input [7:0] a_data,
    input [7:0] alu_data,
    input [7:0] ext_data,
    input pc_out_en,
    input ram_out_en,
    input ir_out_en,
    input a_out_en,
    input alu_out_en,
    input ext_out_en,
    output reg [7:0] bus_data
);
    always @(*) begin
        if (ext_out_en)
            bus_data = ext_data;
        else if (pc_out_en)
            bus_data = pc_data;
        else if (ram_out_en)
            bus_data = ram_data;
        else if (ir_out_en)
            bus_data = ir_data;
        else if (a_out_en)
            bus_data = a_data;
        else if (alu_out_en)
            bus_data = alu_data;
        else
            bus_data = 8'h00;
    end
endmodule
