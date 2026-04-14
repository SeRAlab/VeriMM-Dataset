`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg button;
    reg [3:0] input_value;
    reg reset;
    reg set;
    wire [6:0] displayed_value;
    wire [3:0] output_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .button(button),
        .input_value(input_value),
        .reset(reset),
        .set(set),
        .displayed_value(displayed_value),
        .output_value(output_value)
    );

    // Clock generation (10ns period)
    initial begin
        button = 0;
        forever #5 button = ~button;
    end

        task reset_dut;

        begin
            reset = 1;
            set = 0;
            input_value = 4'd0;
            @(posedge button);
            #2 reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Reset", test_num);
            reset_dut();

            #1;


            check_outputs(7'b0111111, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Set to 5", test_num);
            reset_dut();
            input_value = 4'd5;
            set = 1;
            @(posedge button);
            #2 set = 0;

            #1;


            check_outputs(7'b1101101, 4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Increment from 0 to 3", test_num);
            reset_dut();
            @(posedge button);
            @(posedge button);
            @(posedge button);
            #2;

            #1;


            check_outputs(7'b1001111, 4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Wrap around 9 to 0", test_num);
            reset_dut();
            input_value = 4'd9;
            set = 1;
            @(posedge button);
            #2 set = 0;
            @(posedge button);
            #2;

            #1;


            check_outputs(7'b0111111, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Set 8 then increment twice (8->9->0)", test_num);
            reset_dut();
            input_value = 4'd8;
            set = 1;
            @(posedge button);
            #2 set = 0;
            @(posedge button);
            @(posedge button);
            #2;
            #1;

            check_outputs(7'b0111111, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Reset priority", test_num);
            reset_dut();
            input_value = 4'd7;
            set = 1;
            reset = 1;
            @(posedge button);
            #2 reset = 0; set = 0;
            #1;

            check_outputs(7'b0111111, 4'd0);
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
        input [6:0] expected_displayed_value;
        input [3:0] expected_output_value;
        begin
            if (expected_displayed_value === (expected_displayed_value ^ displayed_value ^ expected_displayed_value) &&
                expected_output_value === (expected_output_value ^ output_value ^ expected_output_value)) begin
                $display("PASS");
                $display("  Outputs: displayed_value=%h, output_value=%h",
                         displayed_value, output_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: displayed_value=%h, output_value=%h",
                         expected_displayed_value, expected_output_value);
                $display("  Got:      displayed_value=%h, output_value=%h",
                         displayed_value, output_value);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,button, input_value, reset, set, displayed_value, output_value);
    end

endmodule
