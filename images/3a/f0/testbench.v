`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [3:0] ALUop;
    reg [15:0] B;
    wire [15:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .ALUop(ALUop),
        .B(B),
        .result(result),
        .zero(zero)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Addition (1 + 1)", test_num);
        A = 16'h0001;
        B = 16'h0001;
        ALUop = 4'b0000;
        #1;

        check_outputs(16'h0002, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Addition (0 + 0)", test_num);
        A = 16'h0000;
        B = 16'h0000;
        ALUop = 4'b0000;
        #1;

        check_outputs(16'h0000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Addition (0xFFFF + 1)", test_num);
        A = 16'hFFFF;
        B = 16'h0001;
        ALUop = 4'b0000;
        #1;

        check_outputs(16'h0000, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Subtraction (10 - 4)", test_num);
        A = 16'h000A;
        B = 16'h0004;
        ALUop = 4'b0001;
        #1;

        check_outputs(16'h0006, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Subtraction (5 - 5)", test_num);
        A = 16'h0005;
        B = 16'h0005;
        ALUop = 4'b0001;
        #1;

        check_outputs(16'h0000, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Bitwise AND (0xF0F0 & 0xAAAA)", test_num);
        A = 16'hF0F0;
        B = 16'hAAAA;
        ALUop = 4'b0010;
        #1;

        check_outputs(16'hA0A0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Bitwise OR (0xF0F0 | 0x0F0F)", test_num);
        A = 16'hF0F0;
        B = 16'h0F0F;
        ALUop = 4'b0011;
        #1;

        check_outputs(16'hFFFF, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Bitwise XOR (0xFFFF ^ 0xAAAA)", test_num);
        A = 16'hFFFF;
        B = 16'hAAAA;
        ALUop = 4'b0100;
        #1;

        check_outputs(16'h5555, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %03d: Logical Left Shift (0x8001 << 1)", test_num);
        A = 16'h8001;
        B = 16'h0000;
        ALUop = 4'b0101;
        #1;

        check_outputs(16'h0002, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %03d: Logical Right Shift (0x8001 >> 1)", test_num);
        A = 16'h8001;
        B = 16'h0000;
        ALUop = 4'b0110;
        #1;

        check_outputs(16'h4000, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %03d: SLT (5 < 10)", test_num);
        A = 16'h0005;
        B = 16'h000A;
        ALUop = 4'b0111;
        #1;

        check_outputs(16'h0001, 1'b0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %03d: SLT (10 < 5)", test_num);
        A = 16'h000A;
        B = 16'h0005;
        ALUop = 4'b0111;
        #1;

        check_outputs(16'h0000, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [15:0] expected_result;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: result=%h, zero=%b",
                         result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, zero=%b",
                         expected_result, expected_zero);
                $display("  Got:      result=%h, zero=%b",
                         result, zero);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule
