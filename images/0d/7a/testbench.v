`timescale 1ns/1ps

module DAC_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] binary_input;
    reg latch;
    wire [15:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC dut (
        .binary_input(binary_input),
        .latch(latch),
        .analog_output(analog_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Minimum Binary Input (0x0000)");

            latch = 0;
            binary_input = 16'h0000;
            #10;

            latch = 1;
            binary_input = 16'h0000;
            #10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Maximum Binary Input (0xFFFF)");

            latch = 0;
            binary_input = 16'h0000;
            #10;

            latch = 1;
            binary_input = 16'hFFFF;
            #10;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Intermediate Binary Input (0x8000)");

            latch = 0;
            binary_input = 16'h0000;
            #10;

            latch = 1;
            binary_input = 16'h8000;
            #10;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Latch Hold Mechanism - Input changes while latch is LOW");

            latch = 1;
            binary_input = 16'hAAAA;
            #10;

            latch = 0;
            binary_input = 16'h5555;
            #10;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Latch Update Mechanism - Enable latch after input change");

            latch = 0;
            binary_input = 16'h1234;
            #10;

            latch = 1;
            #10;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Multiple sequential updates");

            latch = 0;
            binary_input = 16'h0000;
            #10;

            latch = 1;
            binary_input = 16'h1111; #10;
            binary_input = 16'h2222; #10;
            binary_input = 16'h3333; #10;
            #1;

            check_outputs(16'h3333);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Glitch Filter Check (Latch disabled during transition)");

            latch = 1;
            binary_input = 16'hCCCC;
            #10;

            latch = 0;
            binary_input = 16'h0000; #5;
            binary_input = 16'hFFFF; #5;
            binary_input = 16'h1234; #5;
            #1;

            check_outputs(16'hCCCC);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC Testbench");
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
        input [15:0] expected_analog_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_analog_output === (expected_analog_output ^ analog_output ^ expected_analog_output)) begin
                $display("PASS");
                $display("  Outputs: analog_output=%h",
                         analog_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: analog_output=%h",
                         expected_analog_output);
                $display("  Got:      analog_output=%h",
                         analog_output);
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
