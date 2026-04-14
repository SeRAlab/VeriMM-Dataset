`timescale 1ns/1ps

module dac8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] input_value;
    wire [11:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dac8bit dut (
        .input_value(input_value),
        .analog_output(analog_output)
    );
    task testcase001;

    begin
        $display("\nTest Case 001: Minimum Input (0.0V)");
        test_num = 1;
        input_value = 8'h00;

        #1;


        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        $display("\nTest Case 002: Maximum Input (5.0V)");
        test_num = 2;
        input_value = 8'hFF;

        #1;


        check_outputs(12'h4FB);
    end
        endtask

    task testcase003;

    begin
        $display("\nTest Case 003: Mid-scale Input (~2.5V)");
        test_num = 3;
        input_value = 8'h80;

        #1;


        check_outputs(12'h280);
    end
        endtask

    task testcase004;

    begin
        $display("\nTest Case 004: 1.0V equivalent step");
        test_num = 4;
        input_value = 8'd51;

        #1;


        check_outputs(12'h0FF);
    end
        endtask

    task testcase005;

    begin
        $display("\nTest Case 005: 4.0V equivalent step");
        test_num = 5;
        input_value = 8'd204;

        #1;


        check_outputs(12'h3FC);
    end
        endtask

    task testcase006;

    begin
        $display("\nTest Case 006: Small value test");
        test_num = 6;
        input_value = 8'h0A;

        #1;


        check_outputs(12'h032);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dac8bit Testbench");
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
        input [11:0] expected_analog_output;
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
