`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg reset;
    wire [8:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .en(en),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            en = 0;
            #15;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Initial reset check", test_num);
            reset_dut();

            #1;


            check_outputs(9'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single cycle increment", test_num);
            reset_dut();
            en = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(9'h001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable low prevents increment", test_num);
            reset_dut();
            en = 1;
            @(posedge clk);
            en = 0;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(9'h001);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Counting to 15", test_num);
            reset_dut();
            en = 1;
            for (i = 0; i < 15; i = i + 1) begin
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(9'h00F);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rollover check (511 -> 0)", test_num);
            reset_dut();
            en = 1;

            for (i = 0; i < 512; i = i + 1) begin
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous reset mid-cycle", test_num);
            reset_dut();
            en = 1;
            @(posedge clk);
            @(posedge clk);
            #3;
            reset = 1;
            #1;
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset priority over enable", test_num);
            reset_dut();
            en = 1;
            reset = 1;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Toggling enable", test_num);
            reset_dut();
            en = 1; @(posedge clk);
            en = 0; @(posedge clk);
            en = 1; @(posedge clk);
            en = 0; @(posedge clk);
            en = 1; @(posedge clk);
            #2;
            #1;

            check_outputs(9'h003);
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
        input [8:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, en, reset, q);
    end

endmodule
