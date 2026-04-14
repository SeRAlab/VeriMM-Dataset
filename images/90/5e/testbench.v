`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [17:0] signals;
    wire [9:0] actions;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .signals(signals),
        .actions(actions)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            signals = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify reset clears outputs", test_num);
            reset_dut();

            #1;


            check_outputs(10'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No input signals active", test_num);
            reset_dut();
            signals = 18'h00000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Activate Action 0", test_num);
            reset_dut();
            signals = 18'h00001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Activate Action 1", test_num);
            reset_dut();
            signals = 18'h00002;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h002);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Activate Action 2", test_num);
            reset_dut();
            signals = 18'h00004;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h004);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Activate Action 4", test_num);
            reset_dut();
            signals = 18'h00010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h010);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Activate Action 7", test_num);
            reset_dut();
            signals = 18'h00080;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h080);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Activate Action 9", test_num);
            reset_dut();
            signals = 18'h00200;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h200);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signals outside defined action range", test_num);
            reset_dut();
            signals = 18'h3FC00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple signals active (Checking mutual exclusion)", test_num);
            reset_dut();
            signals = 18'h00003;
            @(posedge clk);
            #1;


            if (actions == 10'h001 || actions == 10'h002) begin

                if ($countones(actions) == 1)
                    #1;

                    check_outputs(actions);
                else
                    #1;

                    check_outputs(10'h001);
            end else begin
                #1;

                check_outputs(10'h001);
            end
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential action switching", test_num);
            reset_dut();
            signals = 18'h00001;
            @(posedge clk);
            #1;
            signals = 18'h00004;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h004);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset while signals are active", test_num);
            reset_dut();
            signals = 18'h003FF;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            #1;

            check_outputs(10'h000);
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
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [9:0] expected_actions;
        begin
            if (expected_actions === (expected_actions ^ actions ^ expected_actions)) begin
                $display("PASS");
                $display("  Outputs: actions=%h",
                         actions);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: actions=%h",
                         expected_actions);
                $display("  Got:      actions=%h",
                         actions);
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
        $dumpvars(0,clk, reset, signals, actions);
    end

endmodule
