`timescale 1ns/1ps

module DAC_24_to_10_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] digital_input;
    reg valid;
    wire [9:0] analog_output;
    wire output_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_24_to_10 dut (
        .digital_input(digital_input),
        .valid(valid),
        .analog_output(analog_output),
        .output_valid(output_valid)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros, Valid High", test_num);
        digital_input = 24'h000000;
        valid = 1'b1;
        #1;

        check_outputs(10'h000, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones, Valid High", test_num);
        digital_input = 24'hFFFFFF;
        valid = 1'b1;
        #1;

        check_outputs(10'h3FF, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Arbitrary Pattern 1 (A5A5A5), Valid High", test_num);
        digital_input = 24'hA5A5A5;
        valid = 1'b1;
        #1;

        check_outputs(10'h296, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Arbitrary Pattern 2 (123456), Valid Low", test_num);
        digital_input = 24'h123456;
        valid = 1'b0;
        #1;

        check_outputs(10'h048, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Midpoint Value, Valid High", test_num);
        digital_input = 24'h800000;
        valid = 1'b1;
        #1;

        check_outputs(10'h200, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary Check - LSBs only, Valid High", test_num);

        digital_input = 24'h003FFF;
        valid = 1'b1;
        #1;

        check_outputs(10'h000, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary Check - MSB Bit 14 set, Valid High", test_num);

        digital_input = 24'h004000;
        valid = 1'b1;
        #1;

        check_outputs(10'h001, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_24_to_10 Testbench");
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
        input [9:0] expected_analog_output;
        input expected_output_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_analog_output === (expected_analog_output ^ analog_output ^ expected_analog_output) &&
                expected_output_valid === (expected_output_valid ^ output_valid ^ expected_output_valid)) begin
                $display("PASS");
                $display("  Outputs: analog_output=%h, output_valid=%b",
                         analog_output, output_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: analog_output=%h, output_valid=%b",
                         expected_analog_output, expected_output_valid);
                $display("  Got:      analog_output=%h, output_valid=%b",
                         analog_output, output_valid);
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
