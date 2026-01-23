module alu_tb;

    logic [3:0] A, B;
    logic [3:0] ALU_Sel;
    logic [3:0] Result;
    logic Carry, Zero, Greater;

    // DUT
    alu_4bit dut (
        .A(A),
        .B(B),
        .ALU_Sel(ALU_Sel),
        .Result(Result),
        .Carry(Carry),
        .Zero(Zero),
        .Greater(Greater)
    );

    // Golden reference model
    function automatic [3:0] golden_result;
        input [3:0] a, b;
        input [3:0] sel;
        begin
            case(sel)
                4'h0: golden_result = a + b;
                4'h1: golden_result = a - b;
                4'h2: golden_result = a & b;
                4'h3: golden_result = a | b;
                4'h4: golden_result = a ^ b;
                4'h5: golden_result = ~a;
                4'h6: golden_result = a << 1;
                4'h7: golden_result = a >> 1;
                4'h8: golden_result = a + 1;
                4'h9: golden_result = a - 1;
                4'hA: golden_result = a;
                4'hB: golden_result = b;
                4'hC: golden_result = ~(a & b);
                4'hD: golden_result = ~(a | b);
                4'hE: golden_result = ~(a ^ b);
                4'hF: golden_result = 4'b0000; // compare op
                default: golden_result = 4'b0000;
            endcase
        end
    endfunction

    task check;
        input [3:0] exp;
        begin
            if (Result !== exp) begin
                $display("FAIL | A=%b B=%b Sel=%b | Exp=%b Got=%b",
                          A, B, ALU_Sel, exp, Result);
                $stop;
            end
        end
    endtask

    initial begin
        // Directed tests
        A=4'b0011; B=4'b0001;

        ALU_Sel=4'h0; #5; check(golden_result(A,B,ALU_Sel)); // ADD
        ALU_Sel=4'h1; #5; check(golden_result(A,B,ALU_Sel)); // SUB
        ALU_Sel=4'h6; #5; check(golden_result(A,B,ALU_Sel)); // SHL
        ALU_Sel=4'h7; #5; check(golden_result(A,B,ALU_Sel)); // SHR

        // Random regression
        repeat(500) begin
            A = $random;
            B = $random;
            ALU_Sel = $random;
            #2;
            check(golden_result(A,B,ALU_Sel));
        end

        $display("ALL TESTS PASSED — ALU VERIFIED");
        $finish;
    end

endmodule
