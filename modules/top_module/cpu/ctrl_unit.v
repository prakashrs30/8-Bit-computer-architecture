module ctrl_unit(
    input start,
    input clk,
    input reset,
    input inp_loaded,
    input [3:0] opcode,
    input carry_flag,
    input zero_flag,
    output reg inp_req,
    output [19:0] out,
    output reg [12:0] signal
);
    localparam CO=0, CL=1, CE=2, OI=3, BI=4,
               SUB=5, ALO=6, AO=7, AI=8, IO=9,
               II=10, RO=11, RI=12, MI=13, HLT=14,
               FE=15, XRA=16, ANA=17, ORA=18, INP=19;

    localparam opcode_nop = 4'b0000,
               opcode_lda = 4'b0001,
               opcode_add = 4'b0010,
               opcode_sub = 4'b0011,
               opcode_sta = 4'b0100,
               opcode_out = 4'b0101,
               opcode_jmp = 4'b0110,
               opcode_and = 4'b0111,
               opcode_or  = 4'b1000,
               opcode_xor = 4'b1001,
               opcode_hlt = 4'b1010,
               opcode_jc  = 4'b1011,
               opcode_jz  = 4'b1100;

    localparam t0=3'b000, t1=3'b001, t2=3'b010,
               t3=3'b011, t4=3'b100, t5=3'b101;

    reg [2:0] state;
    reg halted;
    reg [19:0] control;
    assign out = control;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= t0;
            halted <= 1'b0;
        end
        else if (start && !halted) begin
            if (state == t2 && opcode == opcode_hlt)
                halted <= 1'b1;
            else begin
                case (state)
                    t0: state <= t1;
                    t1: state <= t2;
                    t2: state <= t3;
                    t3: state <= t4;
                    t4: state <= t5;
                    t5: state <= t0;
                    default: state <= t0;
                endcase
            end
        end
    end

    always @(*) begin
        control = 20'b0;
        signal = 13'b0;
        inp_req = 1'b0;

        if (halted)
            control[HLT] = 1'b1;
        else begin
            case (state)
                t0: begin
                    control[CO] = 1'b1;
                    control[MI] = 1'b1;
                end
                t1: begin
                    control[RO] = 1'b1;
                    control[II] = 1'b1;
                    control[CE] = 1'b1;
                end
                t2: begin
                    case (opcode)
                        opcode_lda, opcode_add, opcode_sub, opcode_sta,
                        opcode_and, opcode_or, opcode_xor: begin
                            control[IO] = 1'b1;
                            control[MI] = 1'b1;
                        end
                        opcode_jmp: begin
                            control[IO] = 1'b1;
                            control[CL] = 1'b1;
                        end
                        opcode_jc: begin
                            if (carry_flag) begin
                                control[IO] = 1'b1;
                                control[CL] = 1'b1;
                            end
                        end
                        opcode_jz: begin
                            if (zero_flag) begin
                                control[IO] = 1'b1;
                                control[CL] = 1'b1;
                            end
                        end
                        opcode_hlt: begin
                            control[HLT] = 1'b1;
                        end
                        default: ;
                    endcase
                end
                t3: begin
                    case (opcode)
                        opcode_lda: begin
                            control[RO] = 1'b1;
                            control[AI] = 1'b1;
                        end
                        opcode_add, opcode_sub, opcode_and, opcode_or, opcode_xor: begin
                            control[RO] = 1'b1;
                            control[BI] = 1'b1;
                        end
                        opcode_sta: begin
                            control[AO] = 1'b1;
                            control[RI] = 1'b1;
                        end
                        opcode_out: begin
                            control[AO] = 1'b1;
                            control[OI] = 1'b1;
                        end
                        default: ;
                    endcase
                end
                t4: begin
                    case (opcode)
                        opcode_add: begin
                            control[ALO] = 1'b1;
                            control[AI]  = 1'b1;
                            control[FE]  = 1'b1;
                        end
                        opcode_sub: begin
                            control[ALO] = 1'b1;
                            control[AI]  = 1'b1;
                            control[SUB] = 1'b1;
                            control[FE]  = 1'b1;
                        end
                        opcode_and: begin
                            control[ALO] = 1'b1;
                            control[AI]  = 1'b1;
                            control[ANA] = 1'b1;
                            control[FE]  = 1'b1;
                        end
                        opcode_or: begin
                            control[ALO] = 1'b1;
                            control[AI]  = 1'b1;
                            control[ORA] = 1'b1;
                            control[FE]  = 1'b1;
                        end
                        opcode_xor: begin
                            control[ALO] = 1'b1;
                            control[AI]  = 1'b1;
                            control[XRA] = 1'b1;
                            control[FE]  = 1'b1;
                        end
                        default: ;
                    endcase
                end
                default: ;
            endcase
        end

        signal[0]  = control[CO];
        signal[1]  = control[CE];
        signal[2]  = control[AI];
        signal[3]  = control[AO];
        signal[4]  = control[SUB];
        signal[5]  = control[ALO];
        signal[6]  = control[BI];
        signal[7]  = control[RO];
        signal[8]  = control[MI];
        signal[9]  = control[RI];
        signal[10] = control[CL];
        signal[11] = control[II];
        signal[12] = control[IO];
    end
endmodule
