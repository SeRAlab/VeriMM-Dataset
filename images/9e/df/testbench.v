`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg reset;
    reg [15:0] switch_input;
    wire [7:0] green_led_output;
    wire [7:0] red_led_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .reset(reset),
        .switch_input(switch_input),
        .green_led_output(green_led_output),
        .red_led_output(red_led_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Asserted", test_num);
            reset = 1'b1;
            switch_input = 16'hFFFF;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset De-asserted, All Switches OFF", test_num);
            reset = 1'b0;
            switch_input = 16'h0000;

            #1;


            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset De-asserted, All Switches ON", test_num);
            reset = 1'b0;
            switch_input = 16'hFFFF;

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Pattern (0xAA55)", test_num);
            reset = 1'b0;
            switch_input = 16'hAA55;


            #1;



            check_outputs(8'h55, 8'hAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Pattern (0xF00F)", test_num);
            reset = 1'b0;
            switch_input = 16'hF00F;


            #1;



            check_outputs(8'h0F, 8'hF0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Pattern (0x1234)", test_num);
            reset = 1'b0;
            switch_input = 16'h1234;


            #1;



            check_outputs(8'hED, 8'hCB);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Re-asserting Reset", test_num);
            reset = 1'b0;
            switch_input = 16'h1234;
            #5;
            reset = 1'b1;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [7:0] expected_green_led_output;
        input [7:0] expected_red_led_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_green_led_output === (expected_green_led_output ^ green_led_output ^ expected_green_led_output) &&
                expected_red_led_output === (expected_red_led_output ^ red_led_output ^ expected_red_led_output)) begin
                $display("PASS");
                $display("  Outputs: green_led_output=%h, red_led_output=%h",
                         green_led_output, red_led_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: green_led_output=%h, red_led_output=%h",
                         expected_green_led_output, expected_red_led_output);
                $display("  Got:      green_led_output=%h, red_led_output=%h",
                         green_led_output, red_led_output);
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
