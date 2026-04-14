`timescale 1ns/1ps

module DAC_Controller_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] digital_input;
    reg enable;
    wire [11:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_Controller dut (
        .digital_input(digital_input),
        .enable(enable),
        .analog_output(analog_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Disabled State Check", test_num);
            digital_input = 24'hFFFFFF;
            enable = 1'b0;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enabled - All Zeros", test_num);
            digital_input = 24'h000000;
            enable = 1'b1;
            #1;

            check_outputs(12'h000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enabled - All Ones", test_num);
            digital_input = 24'hFFFFFF;
            enable = 1'b1;
            #1;

            check_outputs(12'hFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enabled - Upper Bit Extraction (0xABCDEF)", test_num);
            digital_input = 24'hABCDEF;
            enable = 1'b1;
            #1;

            check_outputs(12'hABC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enabled - Lower Bits Independence", test_num);
            digital_input = 24'h123000;
            enable = 1'b1;
            #5;
            digital_input = 24'h123FFF;
            #1;

            check_outputs(12'h123);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enabled - Alternating Bit Pattern", test_num);
            digital_input = 24'h5A5A5A;
            enable = 1'b1;
            #1;

            check_outputs(12'h5A5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Dynamic Enable Toggle", test_num);
            digital_input = 24'hFEDCBA;
            enable = 1'b1;
            #5;
            enable = 1'b0;
            #1;

            check_outputs(12'h000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_Controller Testbench");
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
