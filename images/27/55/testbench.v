`timescale 1ns/1ps

module comparator_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    wire A_eq_B;
    wire A_gt_B;
    wire A_lt_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_16bit dut (
        .A(A),
        .B(B),
        .A_eq_B(A_eq_B),
        .A_gt_B(A_gt_B),
        .A_lt_B(A_lt_B)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Equality at Zero", test_num);
            A = 16'h0000;
            B = 16'h0000;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Equality at Max Value", test_num);
            A = 16'hFFFF;
            B = 16'hFFFF;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: A Greater Than B (MSB Difference)", test_num);
            A = 16'h8000;
            B = 16'h7FFF;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: A Less Than B (MSB Difference)", test_num);
            A = 16'h7FFF;
            B = 16'h8000;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: A Greater Than B (LSB Difference)", test_num);
            A = 16'h0001;
            B = 16'h0000;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: A Less Than B (LSB Difference)", test_num);
            A = 16'h0000;
            B = 16'h0001;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: General Comparison (A > B)", test_num);
            A = 16'hABCD;
            B = 16'h1234;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: General Comparison (A < B)", test_num);
            A = 16'h1234;
            B = 16'hABCD;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Bit Patterns (A > B)", test_num);
            A = 16'hAAAA;
            B = 16'h5555;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Values (Max vs Min)", test_num);
            A = 16'hFFFF;
            B = 16'h0000;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comparator_16bit Testbench");
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
        input expected_A_eq_B;
        input expected_A_gt_B;
        input expected_A_lt_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_eq_B === (expected_A_eq_B ^ A_eq_B ^ expected_A_eq_B) &&
                expected_A_gt_B === (expected_A_gt_B ^ A_gt_B ^ expected_A_gt_B) &&
                expected_A_lt_B === (expected_A_lt_B ^ A_lt_B ^ expected_A_lt_B)) begin
                $display("PASS");
                $display("  Outputs: A_eq_B=%b, A_gt_B=%b, A_lt_B=%b",
                         A_eq_B, A_gt_B, A_lt_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_eq_B=%b, A_gt_B=%b, A_lt_B=%b",
                         expected_A_eq_B, expected_A_gt_B, expected_A_lt_B);
                $display("  Got:      A_eq_B=%b, A_gt_B=%b, A_lt_B=%b",
                         A_eq_B, A_gt_B, A_lt_B);
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
