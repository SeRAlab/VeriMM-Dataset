`timescale 1ns/1ps

module adc_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_input;
    wire [7:0] binary_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_decoder dut (
        .adc_input(adc_input),
        .binary_output(binary_output)
    );
    task testcase001;

        begin
            test_num = 1;
            adc_input = 24'h000000;
            $display("Test %0d: Zero Input (0x000000)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            adc_input = 24'h0000FF;
            $display("Test %0d: Input below scaling threshold (0x0000FF)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            adc_input = 24'h000100;
            $display("Test %0d: Minimum scale value (0x000100)", test_num);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            adc_input = 24'h008000;
            $display("Test %0d: Mid-range value (0x008000)", test_num);
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            adc_input = 24'h00FF00;
            $display("Test %0d: Maximum value before clamping (0x00FF00)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            adc_input = 24'h00FFFF;
            $display("Test %0d: Fractional threshold before clamping (0x00FFFF)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            adc_input = 24'h010100;
            $display("Test %0d: Clamping activated (0x010100)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            adc_input = 24'hFFFFFF;
            $display("Test %0d: Maximum ADC input (0xFFFFFF)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            adc_input = 24'h004567;
            $display("Test %0d: Random in-range value (0x004567)", test_num);
            #1;

            check_outputs(8'h45);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_decoder Testbench");
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
        input [7:0] expected_binary_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_binary_output === (expected_binary_output ^ binary_output ^ expected_binary_output)) begin
                $display("PASS");
                $display("  Outputs: binary_output=%h",
                         binary_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: binary_output=%h",
                         expected_binary_output);
                $display("  Got:      binary_output=%h",
                         binary_output);
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
