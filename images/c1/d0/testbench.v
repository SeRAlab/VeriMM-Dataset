`timescale 1ns/1ps

module BLOCK0_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg PHI;
    wire GOUT;
    wire POUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    BLOCK0 dut (
        .A(A),
        .B(B),
        .PHI(PHI),
        .GOUT(GOUT),
        .POUT(POUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=0, B=0", test_num);
            A = 1'b0;
            B = 1'b0;
            PHI = 1'b0;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=0, B=1", test_num);
            A = 1'b0;
            B = 1'b1;
            PHI = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=1, B=0", test_num);
            A = 1'b1;
            B = 1'b0;
            PHI = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=1, B=1", test_num);
            A = 1'b1;
            B = 1'b1;
            PHI = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=0, B=0, PHI=1 (Verify PHI has no effect)", test_num);
            A = 1'b0;
            B = 1'b0;
            PHI = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=1, B=1, PHI=1 (Verify PHI has no effect)", test_num);
            A = 1'b1;
            B = 1'b1;
            PHI = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("BLOCK0 Testbench");
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
        input expected_GOUT;
        input expected_POUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_GOUT === (expected_GOUT ^ GOUT ^ expected_GOUT) &&
                expected_POUT === (expected_POUT ^ POUT ^ expected_POUT)) begin
                $display("PASS");
                $display("  Outputs: GOUT=%b, POUT=%b",
                         GOUT, POUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: GOUT=%b, POUT=%b",
                         expected_GOUT, expected_POUT);
                $display("  Got:      GOUT=%b, POUT=%b",
                         GOUT, POUT);
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
