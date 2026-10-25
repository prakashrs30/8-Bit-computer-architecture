module timer100Mto1 (
    input org100M,
    input rst,
    output reg out1
);
    reg [25:0] counter;

    always @(posedge org100M or posedge rst) begin
        if (rst) begin
            out1    <= 1'b0;
            counter <= 26'b0;
        end
        else begin
            if (counter == 26'd49999999) begin
                counter <= 26'b0;
                out1    <= ~out1;
            end 
            else begin
                counter <= counter + 1;
            end
        end 
    end
endmodule
