`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg pop;
    reg push;
    reg [68:0] rcn_in;
    reg rst;
    wire empty;
    wire full;
    wire [68:0] rcn_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pop(pop),
        .push(push),
        .rcn_in(rcn_in),
        .rst(rst),
        .empty(empty),
        .full(full),
        .rcn_out(rcn_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            push = 0;
            pop = 0;
            rcn_in = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset State");
            test_num = 1;
            reset_dut();

            #1 #1;
 check_outputs(1, 0, rcn_out);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Push/Pop");
            test_num = 2;
            reset_dut();


            rcn_in = 69'hA5A5A5A5A5A5A5A5A;
            push = 1;
            @(posedge clk);
            #1 push = 0;


            pop = 1;
            @(posedge clk);
            #1 pop = 0;


            #1;



            check_outputs(1, 0, 69'hA5A5A5A5A5A5A5A5A);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Fill to Full");
            test_num = 3;
            reset_dut();

            push = 1;
            rcn_in = 69'h1; @(posedge clk);
            rcn_in = 69'h2; @(posedge clk);
            rcn_in = 69'h3; @(posedge clk);
            rcn_in = 69'h4; @(posedge clk);
            #1 push = 0;


            #1;



            check_outputs(0, 1, 69'h1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Full and Drain");
            test_num = 4;
            reset_dut();


            push = 1;
            rcn_in = 69'h111; @(posedge clk);
            rcn_in = 69'h222; @(posedge clk);
            rcn_in = 69'h333; @(posedge clk);
            rcn_in = 69'h444; @(posedge clk);
            #1 push = 0;


            pop = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1 pop = 0;


            #1;



            check_outputs(1, 0, 69'h444);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Pointer Wrap-around");
            test_num = 5;
            reset_dut();


            push = 1;
            rcn_in = 69'hA; @(posedge clk);
            rcn_in = 69'hB; @(posedge clk);
            rcn_in = 69'hC; @(posedge clk);
            #1 push = 0;


            pop = 1;
            @(posedge clk); @(posedge clk); @(posedge clk);
            #1 pop = 0;


            push = 1;
            rcn_in = 69'hD; @(posedge clk);
            rcn_in = 69'hE; @(posedge clk);
            rcn_in = 69'hF; @(posedge clk);
            rcn_in = 69'h10; @(posedge clk);
            #1 push = 0;


            #1;



            check_outputs(0, 1, 69'hD);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Partial Pop check");
            test_num = 6;
            reset_dut();

            push = 1;
            rcn_in = 69'hCAFE; @(posedge clk);
            rcn_in = 69'hBABE; @(posedge clk);
            #1 push = 0;

            pop = 1;
            @(posedge clk);
            #1 pop = 0;


            #1;



            check_outputs(0, 0, 69'hBABE);
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
        input expected_empty;
        input expected_full;
        input [68:0] expected_rcn_out;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_rcn_out === (expected_rcn_out ^ rcn_out ^ expected_rcn_out)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, rcn_out=%h",
                         empty, full, rcn_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, rcn_out=%h",
                         expected_empty, expected_full, expected_rcn_out);
                $display("  Got:      empty=%b, full=%b, rcn_out=%h",
                         empty, full, rcn_out);
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
        $dumpvars(0,clk, pop, push, rcn_in, rst, empty, full, rcn_out);
    end

endmodule
