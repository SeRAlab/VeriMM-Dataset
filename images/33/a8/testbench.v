`timescale 1ns/1ps

module LDO_Control_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] reference_voltage;
    wire enable_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO_Control dut (
        .reference_voltage(reference_voltage),
        .enable_output(enable_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Minimum voltage", test_num);
        reference_voltage = 8'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Maximum voltage", test_num);
        reference_voltage = 8'd255;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Voltage just below threshold (127)", test_num);
        reference_voltage = 8'd127;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Voltage at threshold (128)", test_num);
        reference_voltage = 8'd128;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Low operating voltage (64)", test_num);
        reference_voltage = 8'd64;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: High operating voltage (200)", test_num);
        reference_voltage = 8'd200;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Voltage just above threshold (129)", test_num);
        reference_voltage = 8'd129;
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
        $display("LDO_Control Testbench");
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
        input expected_enable_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_enable_output === (expected_enable_output ^ enable_output ^ expected_enable_output)) begin
                $display("PASS");
                $display("  Outputs: enable_output=%b",
                         enable_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enable_output=%b",
                         expected_enable_output);
                $display("  Got:      enable_output=%b",
                         enable_output);
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
