`timescale 1ns/1ps

module hazard_detection_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] control_signal;
    wire hazard;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hazard_detection dut (
        .control_signal(control_signal),
        .hazard(hazard)
    );
    task reset_signals;

        begin
            control_signal = 4'b0000;
            #20;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Stable input (No transitions)");
            test_num = test_num + 1;
            reset_signals();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single bit transition (0 -> 1)");
            test_num = test_num + 1;
            reset_signals();
            control_signal = 4'b0001;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Double bit transition on Bit 0 (0 -> 1 -> 0)");
            test_num = test_num + 1;
            reset_signals();
            control_signal = 4'b0001;
            #10;
            control_signal = 4'b0000;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Changes on different bits (0000 -> 0001 -> 0011)");
            test_num = test_num + 1;
            reset_signals();
            control_signal = 4'b0001;
            #10;
            control_signal = 4'b0011;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Double bit transition on Bit 2 (0 -> 1 -> 0)");
            test_num = test_num + 1;
            reset_signals();
            control_signal = 4'b0100;
            #10;
            control_signal = 4'b0000;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Transition from high to low and back (1 -> 0 -> 1)");
            test_num = test_num + 1;
            control_signal = 4'b1111;
            #20;
            control_signal = 4'b0111;
            #10;
            control_signal = 4'b1111;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Multiple bits toggling simultaneously (Hazard)");
            test_num = test_num + 1;
            reset_signals();
            control_signal = 4'b1111;
            #10;
            control_signal = 4'b0000;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Walking bit pattern (No consecutive changes on same bit)");
            test_num = test_num + 1;
            reset_signals();
            control_signal = 4'b0001; #10;
            control_signal = 4'b0010; #10;
            control_signal = 4'b0100; #10;
            control_signal = 4'b1000; #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Rapid toggling of a single bit with others static");
            test_num = test_num + 1;
            reset_signals();
            control_signal = 4'b1010; #10;
            control_signal = 4'b1011; #10;
            control_signal = 4'b1010; #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hazard_detection Testbench");
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
        input expected_hazard;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hazard === (expected_hazard ^ hazard ^ expected_hazard)) begin
                $display("PASS");
                $display("  Outputs: hazard=%b",
                         hazard);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hazard=%b",
                         expected_hazard);
                $display("  Got:      hazard=%b",
                         hazard);
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
