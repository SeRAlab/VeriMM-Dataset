`timescale 1ns/1ps

module encoder_4to2_tb;

    // Testbench signals (combinational circuit)
    reg I0;
    reg I1;
    reg I2;
    reg I3;
    wire O0;
    wire O1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    encoder_4to2 dut (
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .O0(O0),
        .O1(O1)
    );
    task testcase001;

        begin
            $display("\nTest Case 001: All inputs low (Expect 00)");
            I3 = 0; I2 = 0; I1 = 0; I0 = 0;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: I0 high (Expect 00)");
            I3 = 0; I2 = 0; I1 = 0; I0 = 1;
            #1;

            check_outputs(0, 0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTest Case 003: I1 high (Expect 01)");
            I3 = 0; I2 = 0; I1 = 1; I0 = 0;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTest Case 004: I2 high (Expect 10)");
            I3 = 0; I2 = 1; I1 = 0; I0 = 0;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            $display("\nTest Case 005: I3 high (Expect 11)");
            I3 = 1; I2 = 0; I1 = 0; I0 = 0;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase006;

        begin
            $display("\nTest Case 006: Multiple inputs - I1 and I0 (Expect 01)");
            I3 = 0; I2 = 0; I1 = 1; I0 = 1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase007;

        begin
            $display("\nTest Case 007: Multiple inputs - I2 and I1 (Expect 10)");
            I3 = 0; I2 = 1; I1 = 1; I0 = 0;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase008;

        begin
            $display("\nTest Case 008: All inputs high - Priority I3 (Expect 11)");
            I3 = 1; I2 = 1; I1 = 1; I0 = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase009;

        begin
            $display("\nTest Case 009: Multiple inputs - I3 and I0 (Expect 11)");
            I3 = 1; I2 = 0; I1 = 0; I0 = 1;
            #1;

            check_outputs(1, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("encoder_4to2 Testbench");
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
        input expected_O0;
        input expected_O1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O0 === (expected_O0 ^ O0 ^ expected_O0) &&
                expected_O1 === (expected_O1 ^ O1 ^ expected_O1)) begin
                $display("PASS");
                $display("  Outputs: O0=%b, O1=%b",
                         O0, O1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O0=%b, O1=%b",
                         expected_O0, expected_O1);
                $display("  Got:      O0=%b, O1=%b",
                         O0, O1);
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
