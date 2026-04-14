`timescale 1ns/1ps

module dac_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] digital_input;
    wire analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dac_16bit dut (
        .digital_input(digital_input),
        .analog_output(analog_output)
    );
    task testcase001;

    begin
        test_num = 1;
        digital_input = 16'h0000;
        $display("Test %0d: digital_input = 16'h%h (Min Value)", test_num, digital_input);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        digital_input = 16'h7FFF;
        $display("Test %0d: digital_input = 16'h%h (Just below threshold)", test_num, digital_input);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        digital_input = 16'h8000;
        $display("Test %0d: digital_input = 16'h%h (Threshold value)", test_num, digital_input);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        digital_input = 16'h8001;
        $display("Test %0d: digital_input = 16'h%h (Just above threshold)", test_num, digital_input);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        digital_input = 16'hFFFF;
        $display("Test %0d: digital_input = 16'h%h (Max Value)", test_num, digital_input);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        digital_input = 16'h1234;
        $display("Test %0d: digital_input = 16'h%h (Random low value)", test_num, digital_input);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        digital_input = 16'hC0DE;
        $display("Test %0d: digital_input = 16'h%h (Random high value)", test_num, digital_input);
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
        $display("dac_16bit Testbench");
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
        input expected_analog_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_analog_output === (expected_analog_output ^ analog_output ^ expected_analog_output)) begin
                $display("PASS");
                $display("  Outputs: analog_output=%b",
                         analog_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: analog_output=%b",
                         expected_analog_output);
                $display("  Got:      analog_output=%b",
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
