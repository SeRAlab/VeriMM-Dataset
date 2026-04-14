`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rd;
    reg reset_n;
    reg wr;
    reg [42:0] wr_data;
    wire almost_empty;
    wire almost_full;
    wire empty;
    wire full;
    wire [42:0] rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd(rd),
        .reset_n(reset_n),
        .wr(wr),
        .wr_data(wr_data),
        .almost_empty(almost_empty),
        .almost_full(almost_full),
        .empty(empty),
        .full(full),
        .rd_data(rd_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rd = 0;
            wr = 0;
            wr_data = 0;
            reset_n = 0;
            repeat(2) @(posedge clk);
            reset_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1, 0, 1, 0, 43'hx);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            wr = 1;
            wr_data = 43'h1ABCDEABCDE;
            @(posedge clk);
            wr = 0;

            #1;


            check_outputs(1, 1, 0, 0, 43'hx);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            wr = 1; wr_data = 43'h111; @(posedge clk);

            wr = 1; wr_data = 43'h222; @(posedge clk);
            wr = 0;

            #1;


            check_outputs(0, 1, 0, 1, 43'hx);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            wr = 1; wr_data = 43'hAAA; @(posedge clk);
            wr = 1; wr_data = 43'hBBB; @(posedge clk);
            wr = 0; rd = 1; @(posedge clk);
            rd = 0;

            #1;


            check_outputs(1, 1, 0, 0, 43'hAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            wr = 1; wr_data = 43'h101; @(posedge clk);
            wr = 1; wr_data = 43'h202; @(posedge clk);
            wr = 0; rd = 1; @(posedge clk);
            rd = 1; @(posedge clk);
            rd = 0;

            #1;


            check_outputs(1, 0, 1, 0, 43'h202);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            wr = 1; wr_data = 43'h555; @(posedge clk);

            wr = 1; wr_data = 43'h666; rd = 1; @(posedge clk);
            wr = 0; rd = 0;

            #1;


            check_outputs(1, 1, 0, 0, 43'h555);
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
        input expected_almost_empty;
        input expected_almost_full;
        input expected_empty;
        input expected_full;
        input [42:0] expected_rd_data;
        begin
            if (expected_almost_empty === (expected_almost_empty ^ almost_empty ^ expected_almost_empty) &&
                expected_almost_full === (expected_almost_full ^ almost_full ^ expected_almost_full) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_rd_data === (expected_rd_data ^ rd_data ^ expected_rd_data)) begin
                $display("PASS");
                $display("  Outputs: almost_empty=%b, almost_full=%b, empty=%b, full=%b, rd_data=%h",
                         almost_empty, almost_full, empty, full, rd_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: almost_empty=%b, almost_full=%b, empty=%b, full=%b, rd_data=%h",
                         expected_almost_empty, expected_almost_full, expected_empty, expected_full, expected_rd_data);
                $display("  Got:      almost_empty=%b, almost_full=%b, empty=%b, full=%b, rd_data=%h",
                         almost_empty, almost_full, empty, full, rd_data);
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
        $dumpvars(0,clk, rd, reset_n, wr, wr_data, almost_empty, almost_full, empty, full, rd_data);
    end

endmodule
