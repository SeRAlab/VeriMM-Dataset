`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg output_enable;
    reg rst;
    reg [23:0] tone_switch_period;
    wire square_wave_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .output_enable(output_enable),
        .rst(rst),
        .tone_switch_period(tone_switch_period),
        .square_wave_out(square_wave_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Check", test_num);
            rst = 1;
            output_enable = 1;
            tone_switch_period = 24'd10;
            #20;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Output Enable Low Check", test_num);
            rst = 1; #10;
            rst = 0;
            output_enable = 0;
            tone_switch_period = 24'd5;
            #100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Toggle Check (Short Period)", test_num);
            rst = 1; #10;
            rst = 0;
            output_enable = 1;
            tone_switch_period = 24'd2;




            #25;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Toggle Check (Longer Period)", test_num);
            rst = 1; #10;
            rst = 0;
            output_enable = 1;
            tone_switch_period = 24'd50;

            #100;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Mid-operation Disable", test_num);
            rst = 1; #10;
            rst = 0;
            output_enable = 1;
            tone_switch_period = 24'd5;
            #50;
            output_enable = 0;
            #20;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Reset during high phase", test_num);
            rst = 1; #10;
            rst = 0;
            output_enable = 1;
            tone_switch_period = 24'd2;
            #25;
            rst = 1;
            #10;
            #1;

            check_outputs(1'b0);
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
        input expected_square_wave_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_square_wave_out === (expected_square_wave_out ^ square_wave_out ^ expected_square_wave_out)) begin
                $display("PASS");
                $display("  Outputs: square_wave_out=%b",
                         square_wave_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: square_wave_out=%b",
                         expected_square_wave_out);
                $display("  Got:      square_wave_out=%b",
                         square_wave_out);
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
