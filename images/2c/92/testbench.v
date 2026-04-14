`timescale 1ns/1ps

module wifi_signal_indicator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] signal_strength;
    wire [2:0] strength_level;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_signal_indicator dut (
        .signal_strength(signal_strength),
        .strength_level(strength_level)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Signal Strength 0 (Weak Boundary Low)");
            signal_strength = 4'd0;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Signal Strength 2 (Weak Mid)");
            signal_strength = 4'd2;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Signal Strength 4 (Weak Boundary High)");
            signal_strength = 4'd4;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Signal Strength 5 (Medium Boundary Low)");
            signal_strength = 4'd5;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Signal Strength 8 (Medium Mid)");
            signal_strength = 4'd8;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Signal Strength 10 (Medium Boundary High)");
            signal_strength = 4'd10;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Signal Strength 11 (Strong Boundary Low)");
            signal_strength = 4'd11;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Signal Strength 13 (Strong Mid)");
            signal_strength = 4'd13;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case 009: Signal Strength 15 (Strong Boundary High)");
            signal_strength = 4'd15;
            #1;

            check_outputs(3'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_signal_indicator Testbench");
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
        input [2:0] expected_strength_level;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_strength_level === (expected_strength_level ^ strength_level ^ expected_strength_level)) begin
                $display("PASS");
                $display("  Outputs: strength_level=%h",
                         strength_level);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: strength_level=%h",
                         expected_strength_level);
                $display("  Got:      strength_level=%h",
                         strength_level);
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
