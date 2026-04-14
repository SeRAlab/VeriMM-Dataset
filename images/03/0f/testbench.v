`timescale 1ns/1ps

module dac_24bit_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] digital_input;
    wire [31:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dac_24bit dut (
        .digital_input(digital_input),
        .analog_output(analog_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Zero input", test_num);
        digital_input = 24'd0;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Maximum input", test_num);
        digital_input = 24'hFFFFFF;
        #1;

        check_outputs(32'd1000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Mid-scale input", test_num);
        digital_input = 24'h800000;
        #1;

        check_outputs(32'd500000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Quarter-scale input", test_num);
        digital_input = 24'h400000;
        #1;

        check_outputs(32'd250000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Three-quarter scale input", test_num);
        digital_input = 24'hC00000;
        #1;

        check_outputs(32'd750000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Arbitrary input 1,234,567", test_num);
        digital_input = 24'd1234567;
        #1;

        check_outputs(32'd73585);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Minimum non-zero input", test_num);
        digital_input = 24'd1;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: High-range input", test_num);
        digital_input = 24'd16700000;
        #1;

        check_outputs(32'd995397);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dac_24bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [31:0] expected_analog_output;
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
