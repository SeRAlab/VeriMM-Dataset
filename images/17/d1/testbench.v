`timescale 1ns/1ps

module LU_Decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] matrix;
    wire [15:0] L;
    wire [15:0] U;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LU_Decomposition dut (
        .matrix(matrix),
        .L(L),
        .U(U)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity Matrix", test_num);
            matrix = 16'h1001;
            #1;

            check_outputs(16'h1001, 16'h1001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple integer division", test_num);
            matrix = 16'h244A;
            #1;

            check_outputs(16'h1021, 16'h2402);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic integer case", test_num);
            matrix = 16'h1237;
            #1;

            check_outputs(16'h1031, 16'h1201);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Diagonal matrix", test_num);
            matrix = 16'h4004;
            #1;

            check_outputs(16'h1001, 16'h4004);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Singular-like matrix (u22=0)", test_num);
            matrix = 16'h2244;
            #1;

            check_outputs(16'h1021, 16'h2200);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All elements non-zero", test_num);
            matrix = 16'h1112;
            #1;

            check_outputs(16'h1011, 16'h1101);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Integer division result 0", test_num);
            matrix = 16'h4226;
            #1;

            check_outputs(16'h1001, 16'h4206);
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
        testcase007();
        
        
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
        input [15:0] expected_L;
        input [15:0] expected_U;
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
