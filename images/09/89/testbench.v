`timescale 1ns/1ps

module adc_8bit_to_3bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] adc_input;
    wire [2:0] scaled_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_8bit_to_3bit dut (
        .adc_input(adc_input),
        .scaled_output(scaled_output)
    );
    task testcase001;

    begin
        test_num = 1;
        adc_input = 8'd0;
        $display("Testcase %0d: Testing minimum value (0)", test_num);
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        adc_input = 8'd31;
        $display("Testcase %0d: Testing level boundary (31 -> 0)", test_num);
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        adc_input = 8'd32;
        $display("Testcase %0d: Testing level boundary (32 -> 1)", test_num);
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        adc_input = 8'd127;
        $display("Testcase %0d: Testing mid-range boundary (127 -> 3)", test_num);
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        adc_input = 8'd128;
        $display("Testcase %0d: Testing mid-range boundary (128 -> 4)", test_num);
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        adc_input = 8'd223;
        $display("Testcase %0d: Testing high-range boundary (223 -> 6)", test_num);
        #1;

        check_outputs(3'd6);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        adc_input = 8'd224;
        $display("Testcase %0d: Testing high-range boundary (224 -> 7)", test_num);
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        adc_input = 8'd255;
        $display("Testcase %0d: Testing maximum value (255)", test_num);
        #1;

        check_outputs(3'd7);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_8bit_to_3bit Testbench");
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
        input [2:0] expected_scaled_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_scaled_output === (expected_scaled_output ^ scaled_output ^ expected_scaled_output)) begin
                $display("PASS");
                $display("  Outputs: scaled_output=%h",
                         scaled_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: scaled_output=%h",
                         expected_scaled_output);
                $display("  Got:      scaled_output=%h",
                         scaled_output);
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
