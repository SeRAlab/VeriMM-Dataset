`timescale 1ns/1ps

module ADC_24_to_32_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] analog_input;
    wire [31:0] digital_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ADC_24_to_32 dut (
        .analog_input(analog_input),
        .digital_output(digital_output)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum Input Value (All Zeros)", test_num);
        analog_input = 24'h000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Input Value (All Ones)", test_num);
        analog_input = 24'hFFFFFF;
        #1;

        check_outputs(32'h00FFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mid-point Value (MSB set)", test_num);
        analog_input = 24'h800000;
        #1;

        check_outputs(32'h00800000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bit Pattern (A's)", test_num);
        analog_input = 24'hAAAAAA;
        #1;

        check_outputs(32'h00AAAAAA);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Arbitrary Hex Pattern", test_num);
        analog_input = 24'h123456;
        #1;

        check_outputs(32'h00123456);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ADC_24_to_32 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [31:0] expected_digital_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_digital_output === (expected_digital_output ^ digital_output ^ expected_digital_output)) begin
                $display("PASS");
                $display("  Outputs: digital_output=%h",
                         digital_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digital_output=%h",
                         expected_digital_output);
                $display("  Got:      digital_output=%h",
                         digital_output);
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
