`timescale 1ns/1ps

module bluetooth_signal_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] signal_strength;
    wire [2:0] signal_quality;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_signal_decoder dut (
        .signal_strength(signal_strength),
        .signal_quality(signal_quality)
    );
    task testcase001;

        begin
            $display("Testcase 001: Input 0 (Min)");
            signal_strength = 5'd0;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Input 7 (Boundary Quality 0)");
            signal_strength = 5'd7;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Input 8 (Boundary Quality 1)");
            signal_strength = 5'd8;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Input 12 (Mid Quality 1)");
            signal_strength = 5'd12;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Input 15 (Boundary Quality 1)");
            signal_strength = 5'd15;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Input 16 (Boundary Quality 2)");
            signal_strength = 5'd16;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Input 23 (Boundary Quality 2)");
            signal_strength = 5'd23;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Input 24 (Boundary Quality 3)");
            signal_strength = 5'd24;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Input 31 (Max)");
            signal_strength = 5'd31;
            #1;

            check_outputs(3'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bluetooth_signal_decoder Testbench");
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
        input [2:0] expected_signal_quality;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_signal_quality === (expected_signal_quality ^ signal_quality ^ expected_signal_quality)) begin
                $display("PASS");
                $display("  Outputs: signal_quality=%h",
                         signal_quality);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal_quality=%h",
                         expected_signal_quality);
                $display("  Got:      signal_quality=%h",
                         signal_quality);
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
