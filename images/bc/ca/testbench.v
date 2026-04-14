`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg m;
    reg n;
    wire q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .m(m),
        .n(n),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            m = 1'b1;
            n = 1'b1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            m = 1'b0;
            n = 1'b0;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Test Case %0d: m=0, n=0 (NOR should be 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            m = 1'b0;
            n = 1'b1;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Test Case %0d: m=0, n=1 (NOR should be 0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            m = 1'b1;
            n = 1'b0;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Test Case %0d: m=1, n=0 (NOR should be 0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            m = 1'b1;
            n = 1'b1;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Test Case %0d: m=1, n=1 (NOR should be 0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            m = 1'b0;
            n = 1'b0;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Test Case %0d: Sequence check 1 (0,0 -> q=1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin

            m = 1'b0;
            n = 1'b0;
            @(posedge clk);
            #1;

            m = 1'b1;
            n = 1'b0;
            @(posedge clk);
            #1;
            test_num = test_num + 1;
            $display("Test Case %0d: Sequence check 2 (1,0 -> q=0)", test_num);
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
        input expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%b",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b",
                         expected_q);
                $display("  Got:      q=%b",
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
        $dumpvars(0,clk, m, n, q);
    end

endmodule
