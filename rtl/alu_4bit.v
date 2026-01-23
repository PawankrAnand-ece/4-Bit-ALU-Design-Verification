module alu_4bit (
    input  [3:0] A,
    input  [3:0] B,
    input  [3:0] ALU_Sel,      // 4-bit select = 16 ops
    output reg [3:0] Result,
    output reg Carry,
    output reg Zero,
    output reg Greater
);

always @(*) begin
    // default values (latch-safe design)
    Result  = 4'b0000;
    Carry   = 1'b0;
    Zero    = 1'b0;
    Greater = 1'b0;

    case (ALU_Sel)

        4'b0000: {Carry, Result} = A + B;        // ADD
        4'b0001: {Carry, Result} = A - B;        // SUB
        4'b0010: Result = A & B;                 // AND
        4'b0011: Result = A | B;                 // OR
        4'b0100: Result = A ^ B;                 // XOR
        4'b0101: Result = ~A;                    // NOT A
        4'b0110: Result = A << 1;                // SHIFT LEFT
        4'b0111: Result = A >> 1;                // SHIFT RIGHT
        4'b1000: {Carry, Result} = A + 1'b1;     // INCREMENT
        4'b1001: {Carry, Result} = A - 1'b1;     // DECREMENT
        4'b1010: Result = A;                     // PASS A
        4'b1011: Result = B;                     // PASS B
        4'b1100: Result = ~(A & B);              // NAND
        4'b1101: Result = ~(A | B);              // NOR
        4'b1110: Result = ~(A ^ B);              // XNOR

        4'b1111: begin                           // COMPARE
            if (A > B)
                Greater = 1'b1;
            else
                Greater = 1'b0;
            Result = 4'b0000;
        end

        default: Result = 4'b0000;

    endcase

    // Zero flag logic
    if (Result == 4'b0000)
        Zero = 1'b1;
end

endmodule
