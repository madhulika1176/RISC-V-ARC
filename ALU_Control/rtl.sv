module alu_control (
    input  logic [2:0] alu_op,
    input  logic [2:0] fn3,
    input  logic [6:0] imm11_5,
    input  logic       fn7_5,
    output logic [4:0] control_out
);

    always_comb begin
        control_out = 5'b00000;   // default: ADD (covers "other" alu_op, no latches)

        case (alu_op)
            // R-type
            3'b000: begin
                case (fn3)
                    3'b000: control_out = fn7_5 ? 5'b00001 : 5'b00000; // SUB / ADD
                    3'b001: control_out = 5'b00101;                    // SLL
                    3'b010: control_out = 5'b01000;                    // SLT
                    3'b011: control_out = 5'b01001;                    // SLTU
                    3'b100: control_out = 5'b00010;                    // XOR
                    3'b101: control_out = fn7_5 ? 5'b00111 : 5'b00110; // SRA / SRL
                    3'b110: control_out = 5'b00011;                    // OR
                    3'b111: control_out = 5'b00100;                    // AND
                    default: control_out = 5'b00000;
                endcase
            end

            // I-type ALU (no SUB)
            3'b001: begin
                case (fn3)
                    3'b000: control_out = 5'b00000;                    // ADDI
                    3'b001: control_out = 5'b00101;                    // SLLI
                    3'b010: control_out = 5'b01000;                    // SLTI
                    3'b011: control_out = 5'b01001;                    // SLTIU
                    3'b100: control_out = 5'b00010;                    // XORI
                    3'b101: control_out = (imm11_5 == 7'h20) ? 5'b00111  // SRAI
                                                             : 5'b00110; // SRLI