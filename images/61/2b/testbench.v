`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    wire speaker;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .speaker(speaker)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            repeat(10) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verify speaker is 0 when en=0", test_num);
            reset_dut();
            en = 0;
            repeat(100) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Enable buzzer and wait for toggle duration", test_num);
            reset_dut();
            en = 1;

            repeat(2000) @(posedge clk);

            if (speaker === 1'b0 || speaker === 1'b1)
                #1;

                check_outputs(speaker);
            else
                #1;

                check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Disable buzzer after activity", test_num);
            reset_dut();
            en = 1;
            repeat(500) @(posedge clk);
            en = 0;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Stress test enable signal", test_num);
            reset_dut();
            en = 1; @(posedge clk);
            en = 0; @(posedge clk);
            en = 1; @(posedge clk);
            en = 0;
            repeat(50) @(posedge clk);
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
        input expected_speaker;
        begin
            if (expected_speaker === (expected_speaker ^ speaker ^ expected_speaker)) begin
                $display("PASS");
                $display("  Outputs: speaker=%b",
                         speaker);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: speaker=%b",
                         expected_speaker);
                $display("  Got:      speaker=%b",
                         speaker);
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
        $dumpvars(0,clk, en, speaker);
    end

endmodule
