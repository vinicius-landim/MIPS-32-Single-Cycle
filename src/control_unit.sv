module control_unit(
    input logic [5:0] inst_op,
    output logic [2:0] writeback,
    output logic [2:0] branch_type,
    output logic [2:0] aluop,
    output logic [1:0] regdst,
    output logic jump,
    output logic memread,
    output logic memwrite,
    output logic alusrc,
    output logic regwrite,
    output logic out,
    output logic in,
    output logic halt,
    output logic io_stall,
    output logic olcd,
    output logic hdread,
    output logic instwrite
);

    parameter   R_type = 6'b000000,
                ADDI = 6'b000001,
                ANDI = 6'b000010,
                ORI = 6'b000011,
                XORI = 6'b000100,
                LW = 6'b000101,
                SW = 6'b000110,
                LUI = 6'b000111,
                BEQ = 6'b001000,
                BNE = 6'b001001,
                BLT = 6'b001010,
                BGT = 6'b001011,
                BLE = 6'b001100,
                BGE = 6'b001101,
                IN = 6'b001110,
                OUT = 6'b001111,
                J = 6'b010000,
                JAL = 6'b010001,
                NOP = 6'b010010,
                HALT = 6'b010011,
                OLCD =  6'b010100,
                HDR = 6'b010101,
                SINST = 6'b010110;


    always_comb begin
        writeback   = 3'b000;
        branch_type = 3'b000;
        aluop       = 3'b000;
        regdst      = 2'b00;
        jump        = 0;
        memread     = 0;
        memwrite    = 0;
        alusrc      = 0;
        regwrite    = 0;
        out         = 0;
        in          = 0;
        halt        = 0;
        io_stall    = 0;
        olcd        = 0;
        hdread      = 0;
        instwrite   = 0;
        
        case(inst_op)
            R_type: begin
                writeback = 3'b001;
                branch_type = 3'b000;
                aluop = 3'b111;
                regdst = 2'b10;
                jump = 0;
                memread = 0;
                memwrite = 0;
                alusrc = 0;
                regwrite = 1;
                out = 0;
                in = 0;
                halt = 0;
                io_stall = 0;
                olcd = 0;
                hdread = 0;
                instwrite = 0;
            end

            ADDI: begin
                writeback = 3'b001;
                branch_type = 3'b000;
                aluop = 3'b000;
                regdst = 2'b01;
                jump = 0;
                memread = 0;
                memwrite = 0;
                alusrc = 1;
                regwrite = 1;
                out = 0;
                in = 0;
                halt = 0;
                io_stall = 0;
                olcd = 0;
                hdread = 0;
                instwrite = 0;
            end

            ANDI: begin
                writeback = 3'b001;
                branch_type = 3'b000;
                aluop = 3'b001;
                regdst = 2'b01;
                jump = 0;
                memread = 0;
                memwrite = 0;
                alusrc = 1;
                regwrite = 1;
                out = 0;
                in = 0;
                halt = 0;
                io_stall = 0;
                olcd = 0;
                hdread = 0;
                instwrite = 0;
            end

            ORI: begin
                writeback = 3'b001;
                branch_type = 3'b000;
                aluop = 3'b010;
                regdst = 2'b01;
                jump = 0;
                memread = 0;
                memwrite = 0;
                alusrc = 1;
                regwrite = 1;
                out = 0;
                in = 0;
                halt = 0;
                io_stall = 0;
                olcd = 0;
                hdread = 0;
                instwrite = 0;
            end

            XORI: begin
                writeback = 3'b001;
                branch_type = 3'b000;
                aluop = 3'b011;
                regdst = 2'b01;
                jump = 0;
                memread = 0;
                memwrite = 0;
                alusrc = 1;
                regwrite = 1;
                out = 0;
                in = 0;
                halt = 0;
                io_stall = 0;
                olcd = 0;
                hdread = 0;
                instwrite = 0;
            end

            LW: begin
                writeback = 3'b000;
                branch_type = 3'b000;
                aluop = 3'b000;
                regdst = 2'b01;
                jump = 0;
                memread = 1;
                memwrite = 0;
                alusrc = 1;
                regwrite = 1;
                out = 0;
                in = 0;
                halt = 0;
                io_stall = 0;
                olcd = 0;
                hdread = 0;
                instwrite = 0;
            end

            SW: begin
                writeback = 3'b000;
                branch_type = 3'b000;
                aluop = 3'b000;
                regdst = 2'b00;
                jump = 0;
                memread = 0;
                memwrite = 1;
                alusrc = 1;
                regwrite = 0;
                out = 0;
                in = 0;
                halt = 0;
                io_stall = 0;
                olcd = 0;
                hdread = 0;
                instwrite = 0;
            end

            LUI: begin
                writeback = 3'b001;
                branch_type = 3'b000;
                aluop = 3'b101;
                regdst = 2'b01;
                jump = 0;
                memread = 0;
                memwrite = 0;
                alusrc = 1;
                regwrite = 1;
                out = 0;
                in = 0;
                halt = 0;
                io_stall = 0;
                olcd = 0;
                hdread = 0;
                instwrite = 0;
            end

            BEQ: begin
                writeback = 3'b000;
                branch_type = 3'b001;
                aluop = 3'b100;
                regdst = 2'b00;
                jump = 0;
                memread = 0;
                memwrite = 0;
                alusrc = 0;
                regwrite = 0;
                out = 0;
                in = 0;
                halt = 0;
                io_stall = 0;
                olcd = 0;
                hdread = 0;
                instwrite = 0;
            end

            BNE: begin
                writeback = 3'b000;
                branch_type = 3'b010;
                aluop = 3'b100;
                regdst = 2'b00;
                jump = 0;
                memread = 0;
                memwrite = 0;
                alusrc = 0;
                regwrite = 0;
                out = 0;
                in = 0;
                halt = 0;
                io_stall = 0;
                olcd = 0;
                hdread = 0;
                instwrite = 0;
            end

            BLT: begin
                writeback = 3'b000;
                branch_type = 3'b011;
                aluop = 3'b100;
                regdst = 2'b00;
                jump = 0;
                memread = 0;
                memwrite = 0;
                alusrc = 0;
                regwrite = 0;
                out = 0;
                in = 0;
                halt = 0;
                io_stall = 0;
                olcd = 0;
                hdread = 0;
                instwrite = 0;
            end

            BGT: begin
                writeback = 3'b000;
                branch_type = 3'b100;
                aluop = 3'b100;
                regdst = 2'b00;
                jump = 0;
                memread = 0;
                memwrite = 0;
                alusrc = 0;
                regwrite = 0;
                out = 0;
                in = 0;
                halt = 0;
                io_stall = 0;
                olcd = 0;
                hdread = 0;
                instwrite = 0;
            end

            BLE: begin
                writeback = 3'b000;
                branch_type = 3'b101;
                aluop = 3'b100;
                regdst = 2'b00;
                jump = 0;
                memread = 0;
                memwrite = 0;
                alusrc = 0;
                regwrite = 0;
                out = 0;
                in = 0;
                halt = 0;
                io_stall = 0;
                olcd = 0;
                hdread = 0;
                instwrite = 0;
            end

            BGE: begin
                writeback = 3'b000;
                branch_type = 3'b110;
                aluop = 3'b100;
                regdst = 2'b00;
                jump = 0;
                memread = 0;
                memwrite = 0;
                alusrc = 0;
                regwrite = 0;
                out = 0;
                in = 0;
                halt = 0;
                io_stall = 0;
                olcd = 0;
                hdread = 0;
                instwrite = 0;
            end

            IN: begin
                writeback = 3'b011;
                branch_type = 3'b000;
                aluop = 3'b000;
                regdst = 2'b01;
                jump = 0;
                memread = 0;
                memwrite = 0;
                alusrc = 0;
                regwrite = 1;
                out = 0;
                in = 1;
                halt = 0;
                io_stall = 1;
                olcd = 0;
                hdread = 0;
                instwrite = 0;
            end

            OUT: begin
                writeback = 3'b100;
                branch_type = 3'b000;
                aluop = 3'b000;
                regdst = 2'b00;
                jump = 0;
                memread = 0;
                memwrite = 0;
                alusrc = 0;
                regwrite = 0;
                out = 1;
                in = 0;
                halt = 0;
                io_stall = 1;
                olcd = 0;
                hdread = 0;
                instwrite = 0;
            end

            J: begin
                writeback = 3'b000;
                branch_type = 3'b000;
                aluop = 3'b000;
                regdst = 2'b00;
                jump = 1;
                memread = 0;
                memwrite = 0;
                alusrc = 0;
                regwrite = 0;
                out = 0;
                in = 0;
                halt = 0;
                io_stall = 0;
                olcd = 0;
                hdread = 0;
                instwrite = 0;
            end

            JAL: begin
                writeback = 3'b010;
                branch_type = 3'b000;
                aluop = 3'b000;
                regdst = 2'b11;
                jump = 1;
                memread = 0;
                memwrite = 0;
                alusrc = 0;
                regwrite = 1;
                out = 0;
                in = 0;
                halt = 0;
                io_stall = 0;
                olcd = 0;
                hdread = 0;
                instwrite = 0;
            end

            NOP: begin
                writeback = 3'b111;
                branch_type = 3'b000;
                aluop = 3'b000;
                regdst = 2'b00;
                jump = 0;
                memread = 0;
                memwrite = 0;
                alusrc = 0;
                regwrite = 0;
                out = 0;
                in = 0;
                halt = 0;
                io_stall = 0;
                olcd = 0;
                hdread = 0;
                instwrite = 0;
            end

            HALT: begin
                writeback = 3'b111;
                branch_type = 3'b000;
                aluop = 3'b000;
                regdst = 2'b00;
                jump = 0;
                memread = 0;
                memwrite = 0;
                alusrc = 0;
                regwrite = 0;
                out = 0;
                in = 0;
                halt = 1;
                io_stall = 0;
                olcd = 0;
                hdread = 0;
                instwrite = 0;
            end

            OLCD: begin
                writeback = 3'b100;
                branch_type = 3'b000;
                aluop = 3'b000;
                regdst = 2'b00;
                jump = 0;
                memread = 0;
                memwrite = 0;
                alusrc = 0;
                regwrite = 0;
                out = 0;
                in = 0;
                halt = 0;
                io_stall = 1;
                olcd = 1;
                hdread = 0;
                instwrite = 0;
            end

            HDR: begin
                writeback = 3'b101;
                branch_type = 3'b000;
                aluop = 3'b000;
                regdst = 2'b01;
                jump = 0;
                memread = 0;
                memwrite = 0;
                alusrc = 0;
                regwrite = 1;
                out = 0;
                in = 0;
                halt = 0;
                io_stall = 0;
                olcd = 0;
                hdread = 1;
                instwrite = 0;
            end
            
            SINST: begin
                writeback = 3'b000;
                branch_type = 3'b000;
                aluop = 3'b000;
                regdst = 2'b00;
                jump = 0;
                memread = 0;
                memwrite = 0;
                alusrc = 1;
                regwrite = 0;
                out = 0;
                in = 0;
                halt = 0;
                io_stall = 0;
                olcd = 0;
                hdread = 0;
                instwrite = 1;
            end
				
            default: begin
                writeback   = 3'b000;
                branch_type = 3'b000;
                aluop       = 3'b000;
                regdst      = 2'b00;
                jump        = 0;
                memread     = 0;
                memwrite    = 0;
                alusrc      = 0;
                regwrite    = 0;
                out         = 0;
                in          = 0;
                halt        = 0;
                io_stall    = 0;
                olcd        = 0;
                hdread      = 0;
                instwrite   = 0;
            end
        endcase
    end

endmodule