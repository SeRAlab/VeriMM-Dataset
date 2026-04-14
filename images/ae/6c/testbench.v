`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg enable;
    reg reset_n;
    reg signal;
    wire [3:0] num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .reset_n(reset_n),
        .signal(signal),
        .num(num)
    );

    // Clock generation (10ns period)
    initial begin
        reset_n = 0;
        forever #5 reset_n = ~reset_n;
    end

        task reset_dut;

        begin
            #5;
            reset_n = 0;
            #15;
            reset_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Power-on Reset", test_num);
            reset_dut();
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Increment", test_num);
            reset_dut();
            enable = 1;
            signal = 0;
            #10;
            signal = 1;
            #10;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable Gating", test_num);
            reset_dut();
            enable = 0;
            signal = 0;
            #10;
            signal = 1;
            #10;
            signal = 0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multi-step Increment", test_num);
            reset_dut();
            enable = 1;
            for (i = 0; i < 5; i = i + 1) begin
                signal = 0; #10;
                signal = 1; #10;
            end
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Wrap-around (15 to 0)", test_num);
            reset_dut();
            enable = 1;
            for (i = 0; i < 16; i = i + 1) begin
                signal = 0; #10;
                signal = 1; #10;
            end
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Asynchronous Reset Mid-count", test_num);
            reset_dut();
            enable = 1;

            repeat(3) begin
                signal = 0; #10;
                signal = 1; #10;
            end

            #5 reset_n = 0;
            #5;
            #1;

            check_outputs(4'd0);
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
        input [3:0] expected_num;
        begin
            if (expected_num === (expected_num ^ num ^ expected_num)) begin
                $display("PASS");
                $display("  Outputs: num=%h",
                         num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: num=%h",
                         expected_num);
                $display("  Got:      num=%h",
                         num);
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
        $dumpvars(0,enable, reset_n, signal, num);
    end

endmodule
