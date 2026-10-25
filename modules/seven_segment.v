`timescale 1ns / 1ps

module seven_seg_controller (
    input clk,                 // 100MHz system clock
    input reset,               // Active-high reset
    input [7:0] val,           // 8-bit binary value from computer (0 to 255)
    output reg [3:0] an,       // Active-low digit anodes (D0_a[3:0])
    output reg [6:0] seg       // Active-low segment cathodes (D0_seg[6:0]: a,b,c,d,e,f,g)
);

    // 1. Binary to Decimal (BCD) conversion
    wire [3:0] hundreds = (val / 100) % 10;
    wire [3:0] tens     = (val / 10) % 10;
    wire [3:0] ones     = val % 10;

    // 2. 18-bit refresh counter (~380 Hz refresh rate for full brightness)
    reg [17:0] refresh_counter;
    always @(posedge clk or posedge reset) begin
        if (reset)
            refresh_counter <= 18'd0;
        else
            refresh_counter <= refresh_counter + 1;
    end

    wire [1:0] digit_select = refresh_counter[17:16];

    // 3. Digit multiplexing - All 4 digits actively driven (displays 0055)
    reg [3:0] current_digit;

    always @(*) begin
        case (digit_select)
            2'b00: begin // Digit 0: Ones place (rightmost digit)
                an = 4'b1110;
                current_digit = ones;
            end
            2'b01: begin // Digit 1: Tens place
                an = 4'b1101;
                current_digit = tens;
            end
            2'b10: begin // Digit 2: Hundreds place
                an = 4'b1011;
                current_digit = hundreds;
            end
            2'b11: begin // Digit 3: Thousands place (leftmost digit)
                an = 4'b0111;
                current_digit = 4'd0;
            end
        endcase
    end

    // 4. Active-Low 7-Segment Cathode Decoder
    // seg[0]=a, seg[1]=b, seg[2]=c, seg[3]=d, seg[4]=e, seg[5]=f, seg[6]=g
    always @(*) begin
        case (current_digit)
            4'd0: seg = 7'b1000000; // 0
            4'd1: seg = 7'b1111001; // 1
            4'd2: seg = 7'b0100100; // 2
            4'd3: seg = 7'b0110000; // 3
            4'd4: seg = 7'b0011001; // 4
            4'd5: seg = 7'b0010010; // 5
            4'd6: seg = 7'b0000010; // 6
            4'd7: seg = 7'b1111000; // 7
            4'd8: seg = 7'b0000000; // 8
            4'd9: seg = 7'b0010000; // 9
            default: seg = 7'b1111111;
        endcase
    end

endmodule
