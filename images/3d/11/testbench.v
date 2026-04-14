`timescale 1ns/1ps

module DAC_24_to_8_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] digital_input;
    reg [3:0] scaling_factor;
    wire [7:0] analog_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_24_to_8 dut (
        .digital_input(digital_input),
        .scaling_factor(scaling_factor),
        .analog_output(analog_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            digital_input = 24'h000000;
            scaling_factor = 4'h0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Max Input, Zero Scaling", test_num);
            digital_input = 24'hFFFFFF;
            scaling_factor = 4'h0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Max Input, Unity Scaling", test_num);
            digital_input = 24'hFFFFFF;
            scaling_factor = 4'h1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid Input, Unity Scaling", test_num);
            digital_input = 24'h800000;
            scaling_factor = 4'h1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Clamping Boundary (256 -> 255)", test_num);
            digital_input = 24'h800000;
            scaling_factor = 4'h2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Scale Mid-range Input by 2", test_num);
            digital_input = 24'h400000;
            scaling_factor = 4'h2;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Max Input, Max Scaling (Extreme Clamp)", test_num);
            digital_input = 24'hFFFFFF;
            scaling_factor = 4'hF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Small Input, Large Scaling", test_num);
            digital_input = 24'h010000;
            scaling_factor = 4'hF;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Sub-threshold Input", test_num);
            digital_input = 24'h008000;
            scaling_factor = 4'h2;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Arbitrary Value Scaling", test_num);
            digital_input = 24'h123456;
            scaling_factor = 4'h2;
            #1;

            check_outputs(8'h24);
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
