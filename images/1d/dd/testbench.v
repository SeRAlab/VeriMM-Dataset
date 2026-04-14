`timescale 1ns/1ps

module dac_controller_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] digital_input;
    reg [23:0] threshold;
    wire [23:0] analog_output;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dac_controller dut (
        .digital_input(digital_input),
        .threshold(threshold),
        .analog_output(analog_output),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input less than threshold", test_num);
            digital_input = 24'h000010;
            threshold     = 24'h000100;
            #1;

            check_outputs(24'h000010, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input equal to threshold", test_num);
            digital_input = 24'hABCDEF;
            threshold     = 24'hABCDEF;

            #1;


            check_outputs(24'hABCDEF, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input greater than threshold", test_num);
            digital_input = 24'hFFFFFF;
            threshold     = 24'h000000;
            #1;

            check_outputs(24'hFFFFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input slightly greater than threshold", test_num);
            digital_input = 24'h800001;
            threshold     = 24'h800000;
            #1;

            check_outputs(24'h800001, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Both zero", test_num);
            digital_input = 24'h000000;
            threshold     = 24'h000000;
            #1;

            check_outputs(24'h000000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Threshold at max", test_num);
            digital_input = 24'hFFFFFE;
            threshold     = 24'hFFFFFF;
            #1;

            check_outputs(24'hFFFFFE, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large values comparison", test_num);
            digital_input = 24'hE00000;
            threshold     = 24'hD00000;
            #1;

            check_outputs(24'hE00000, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dac_controller Testbench");
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
        input [23:0] expected_analog_output;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_analog_output === (expected_analog_output ^ analog_output ^ expected_analog_output) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: analog_output=%h, valid=%b",
                         analog_output, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: analog_output=%h, valid=%b",
                         expected_analog_output, expected_valid);
                $display("  Got:      analog_output=%h, valid=%b",
                         analog_output, valid);
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
