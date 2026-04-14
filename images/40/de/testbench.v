`timescale 1ns/1ps

module lu_decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    wire [3:0] L;
    wire [3:0] U;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    lu_decomposition dut (
        .A(A),
        .L(L),
        .U(U)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 8'h41;
        $display("Test Case 001: Identity Matrix");
        #1;

        check_outputs(8'h41, 8'h41);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 8'h95;
        $display("Test Case 002: Basic (l21=1, u22=1)");
        #1;

        check_outputs(8'h51, 8'h45);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 8'hD5;
        $display("Test Case 003: Division (l21=2)");
        #1;

        check_outputs(8'h61, 8'h45);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 8'hAA;
        $display("Test Case 004: Singular Result (u22=0)");
        #1;

        check_outputs(8'h51, 8'h0A);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 8'hC7;
        $display("Test Case 005: Zero l21");
        #1;

        check_outputs(8'h41, 8'hC7);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("lu_decomposition Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [3:0] expected_L;
        input [3:0] expected_U;
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
