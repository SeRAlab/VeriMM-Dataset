`timescale 1ns/1ps

module DAC_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] digital_input;
    reg enable;
    wire [15:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_16bit dut (
        .digital_input(digital_input),
        .enable(enable),
        .analog_output(analog_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Min value, Enabled", test_num);
        enable = 1;
        digital_input = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Max value, Enabled", test_num);
        enable = 1;
        digital_input = 16'hFFFF;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Mid-range value (0x7FFF), Enabled", test_num);
        enable = 1;
        digital_input = 16'h7FFF;
        #1;

        check_outputs(16'h7FFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Arbitrary value (0xA5A5), Enabled", test_num);
        enable = 1;
        digital_input = 16'hA5A5;
        #1;

        check_outputs(16'hA5A5);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Max value, Disabled (Should be 0V)", test_num);
        enable = 0;
        digital_input = 16'hFFFF;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Arbitrary value (0x1234), Disabled (Should be 0V)", test_num);
        enable = 0;
        digital_input = 16'h1234;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Zero value, Disabled (Should be 0V)", test_num);
        enable = 0;
        digital_input = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Re-enabling with active input", test_num);
        enable = 0;
        digital_input = 16'hBEEF;
        #5;
        enable = 1;
        #1;

        check_outputs(16'hBEEF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Disabling while outputting value", test_num);
        enable = 1;
        digital_input = 16'hCAFE;
        #5;
        enable = 0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Quarter scale (0x4000), Enabled", test_num);
        enable = 1;
        digital_input = 16'h4000;
        #1;

        check_outputs(16'h4000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_16bit Testbench");
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
