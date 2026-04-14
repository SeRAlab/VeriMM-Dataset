`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg fifo_empty;
    reg rd;
    reg rst_n;
    wire fifo_rd;
    wire [4:0] rptr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .fifo_empty(fifo_empty),
        .rd(rd),
        .rst_n(rst_n),
        .fifo_rd(fifo_rd),
        .rptr(rptr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 1'b0;
            rd = 1'b0;
            fifo_empty = 1'b0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1'b1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running testcase%03d: Reset Check", test_num);
            reset_dut();
            #1;
            #1;

            check_outputs(1'b0, 5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running testcase%03d: Single Successful Read", test_num);
            reset_dut();
            rd = 1'b1;
            fifo_empty = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 5'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running testcase%03d: Read While Empty", test_num);
            reset_dut();
            rd = 1'b1;
            fifo_empty = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 5'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running testcase%03d: No Read Request", test_num);
            reset_dut();
            rd = 1'b0;
            fifo_empty = 1'b0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 5'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running testcase%03d: Continuous Reads", test_num);
            reset_dut();
            rd = 1'b1;
            fifo_empty = 1'b0;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 5'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running testcase%03d: Pointer Wrap-around", test_num);
            reset_dut();
            rd = 1'b1;
            fifo_empty = 1'b0;
            repeat(32) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 5'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Running testcase%03d: Intermittent Reads", test_num);
            reset_dut();


            rd = 1'b1; fifo_empty = 1'b0;
            @(posedge clk);


            rd = 1'b0; fifo_empty = 1'b0;
            @(posedge clk);


            rd = 1'b1; fifo_empty = 1'b0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b1, 5'd2);
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
        input expected_fifo_rd;
        input [4:0] expected_rptr;
        begin
            if (expected_fifo_rd === (expected_fifo_rd ^ fifo_rd ^ expected_fifo_rd) &&
                expected_rptr === (expected_rptr ^ rptr ^ expected_rptr)) begin
                $display("PASS");
                $display("  Outputs: fifo_rd=%b, rptr=%h",
                         fifo_rd, rptr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fifo_rd=%b, rptr=%h",
                         expected_fifo_rd, expected_rptr);
                $display("  Got:      fifo_rd=%b, rptr=%h",
                         fifo_rd, rptr);
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
        $dumpvars(0,clk, fifo_empty, rd, rst_n, fifo_rd, rptr);
    end

endmodule
