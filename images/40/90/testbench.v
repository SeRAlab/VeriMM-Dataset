`timescale 1ns/1ps

module DAC_24_to_8_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] digital_input;
    wire [7:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_24_to_8 dut (
        .digital_input(digital_input),
        .analog_output(analog_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Minimum Input (Zero)", test_num);
            digital_input = 24'h000000;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Maximum Input (Saturated/Full Scale)", test_num);
            digital_input = 24'hFFFFFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Mid-range value (0x80xxxx)", test_num);
            digital_input = 24'h80CAFE;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Lower bits don't affect output (0x550000)", test_num);
            digital_input = 24'h550000;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Lower bits don't affect output (0x55FFFF)", test_num);
            digital_input = 24'h55FFFF;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Arbitrary pattern 1", test_num);
            digital_input = 24'hA5A5A5;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Arbitrary pattern 2", test_num);
            digital_input = 24'h123456;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Near saturation boundary", test_num);
            digital_input = 24'hFEFFFF;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Minimal increment in MSB", test_num);
            digital_input = 24'h010000;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Random bits check", test_num);
            digital_input = 24'hBEEF22;
            #1;

            check_outputs(8'hBE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_24_to_8 Testbench");
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
        input [7:0] expected_analog_output;
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
