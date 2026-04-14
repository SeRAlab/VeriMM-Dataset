`timescale 1ns/1ps

module LU_Decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    wire [2:0] L;
    wire [4:0] U;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LU_Decomposition dut (
        .A(A),
        .L(L),
        .U(U)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'b1001;
        $display("Test %0d: Identity Matrix (A=4'b1001)", test_num);
        #1;

        check_outputs(3'b101, 5'b10100);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'b1111;
        $display("Test %0d: All Ones Matrix (A=4'b1111)", test_num);
        #1;

        check_outputs(3'b111, 5'b11000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'b1101;
        $display("Test %0d: Upper Triangular (A=4'b1101)", test_num);
        #1;

        check_outputs(3'b101, 5'b11100);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'b1011;
        $display("Test %0d: Lower Triangular (A=4'b1011)", test_num);
        #1;

        check_outputs(3'b111, 5'b10100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'b1110;
        $display("Test %0d: XOR/Subtraction logic check (A=4'b1110)", test_num);
        #1;

        check_outputs(3'b111, 5'b11100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'b1000;
        $display("Test %0d: Singular Diagonal (A=4'b1000)", test_num);
        #1;

        check_outputs(3'b101, 5'b10000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LU_Decomposition Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [2:0] expected_L;
        input [4:0] expected_U;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_L === (expected_L ^ L ^ expected_L) &&
                expected_U === (expected_U ^ U ^ expected_U)) begin
                $display("PASS");
                $display("  Outputs: L=%h, U=%h",
                         L, U);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: L=%h, U=%h",
                         expected_L, expected_U);
                $display("  Got:      L=%h, U=%h",
                         L, U);
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
