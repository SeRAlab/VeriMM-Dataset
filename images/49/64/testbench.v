`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg note_on;
    reg rst;
    reg [7:0] saw_out;
    wire PWM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .note_on(note_on),
        .rst(rst),
        .saw_out(saw_out),
        .PWM(PWM)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            note_on = 0;
            saw_out = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Note Off (50%% Duty) - Early Cycle", test_num);
            reset_dut();
            note_on = 0;
            #100000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Note Off (50%% Duty) - Late Cycle", test_num);
            reset_dut();
            note_on = 0;
            #600000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Note On (25%% Duty) - Early Cycle", test_num);
            reset_dut();
            note_on = 1;
            saw_out = 8'd64;
            #100000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Note On (25%% Duty) - Late Cycle", test_num);
            reset_dut();
            note_on = 1;
            saw_out = 8'd64;
            #400000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Note On (75%% Duty) - Mid Cycle", test_num);
            reset_dut();
            note_on = 1;
            saw_out = 8'd192;
            #600000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Note On (0%% Duty)", test_num);
            reset_dut();
            note_on = 1;
            saw_out = 8'd0;
            #1000;
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
        input expected_PWM;
        begin
            if (expected_PWM === (expected_PWM ^ PWM ^ expected_PWM)) begin
                $display("PASS");
                $display("  Outputs: PWM=%b",
                         PWM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PWM=%b",
                         expected_PWM);
                $display("  Got:      PWM=%b",
                         PWM);
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
        $dumpvars(0,clk, note_on, rst, saw_out, PWM);
    end

endmodule
