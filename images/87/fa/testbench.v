`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg r;
    reg rst;
    reg s;
    wire q;
    wire qb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .r(r),
        .rst(rst),
        .s(s),
        .q(q),
        .qb(qb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            s = 0;
            r = 0;
            #12;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Asynchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous Set (S=1, R=0)", test_num);
            reset_dut();
            @(posedge clk);
            s <= 1;
            r <= 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous Reset (S=0, R=1)", test_num);
            reset_dut();

            @(posedge clk);
            s <= 1; r <= 0;
            @(posedge clk);

            s <= 0; r <= 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Hold State (Maintaining HIGH)", test_num);
            reset_dut();

            @(posedge clk);
            s <= 1; r <= 0;
            @(posedge clk);

            s <= 0; r <= 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Hold State (Maintaining LOW)", test_num);
            reset_dut();

            @(posedge clk);
            s <= 0; r <= 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Indeterminate State (S=1, R=1)", test_num);
            reset_dut();
            @(posedge clk);
            s <= 1;
            r <= 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'bx, 1'bx);
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
        input expected_qb;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_qb === (expected_qb ^ qb ^ expected_qb)) begin
                $display("PASS");
                $display("  Outputs: q=%b, qb=%b",
                         q, qb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%b, qb=%b",
                         expected_q, expected_qb);
                $display("  Got:      q=%b, qb=%b",
                         q, qb);
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
        $dumpvars(0,clk, r, rst, s, q, qb);
    end

endmodule
