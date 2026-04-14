`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg en;
    wire [2:0] t;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .en(en),
        .t(t)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            en = 0;
            d = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge clk) begin en = 1; d = 1; end
            @(negedge clk) begin en = 1; d = 0; end
            @(negedge clk) begin en = 1; d = 0; end
            @(negedge clk) begin en = 1; d = 0; end
            @(posedge clk);
            #1;
            $display("Testcase %0d: Full Cycle Check", test_num);
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge clk) begin en = 1; d = 1; end
            @(negedge clk) begin en = 1; d = 1; end
            @(posedge clk);
            #1;
            $display("Testcase %0d: Hold State 1 Check", test_num);
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge clk) begin en = 1; d = 1; end
            @(negedge clk) begin en = 1; d = 0; end
            @(posedge clk);
            #1;
            $display("Testcase %0d: State 2 Check", test_num);
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge clk) begin en = 1; d = 1; end
            @(negedge clk) begin en = 1; d = 0; end
            @(negedge clk) begin en = 1; d = 0; end
            @(posedge clk);
            #1;
            $display("Testcase %0d: State 3 Check", test_num);
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge clk) begin en = 1; d = 1; end
            @(negedge clk) begin en = 1; d = 0; end
            @(negedge clk) begin en = 0; d = 1; end
            @(posedge clk);
            #1;
            $display("Testcase %0d: Enable Dominance Check", test_num);
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(negedge clk) begin en = 1; d = 0; end
            @(negedge clk) begin en = 1; d = 0; end
            @(posedge clk);
            #1;
            $display("Testcase %0d: Idle State Check", test_num);
            #1;

            check_outputs(3'd0);
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
        input [2:0] expected_t;
        begin
            if (expected_t === (expected_t ^ t ^ expected_t)) begin
                $display("PASS");
                $display("  Outputs: t=%h",
                         t);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: t=%h",
                         expected_t);
                $display("  Got:      t=%h",
                         t);
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
        $dumpvars(0,clk, d, en, t);
    end

endmodule
