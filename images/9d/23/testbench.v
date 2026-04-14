`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rd;
    reg reset_n;
    reg wr;
    reg [7:0] wr_data;
    wire almost_empty;
    wire almost_full;
    wire empty;
    wire full;
    wire [7:0] rd_data;

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
        reset_n = 0;
        wr = 0;
        rd = 0;
        wr_data = 0;
        @(posedge clk);
        #1;
        reset_n = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Initial state", test_num);
        reset_dut();

        #1;


        check_outputs(1, 0, 1, 0, 8'hxx);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Single write", test_num);
        reset_dut();
        wr = 1; wr_data = 8'hAA;
        @(posedge clk);
        #1;
        wr = 0;

        #1;


        check_outputs(1, 1, 0, 0, 8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Fill to full", test_num);
        reset_dut();
        wr = 1; wr_data = 8'h11;
        @(posedge clk);
        #1;
        wr = 1; wr_data = 8'h22;
        @(posedge clk);
        #1;
        wr = 0;

        #1;


        check_outputs(0, 1, 0, 1, 8'h11);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Read from full", test_num);
        reset_dut();

        wr = 1; wr_data = 8'h11;
        @(posedge clk);
        wr_data = 8'h22;
        @(posedge clk);

        wr = 0; rd = 1;
        @(posedge clk);
        #1;
        rd = 0;


        #1;



        check_outputs(1, 1, 0, 0, 8'h22);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Read until empty", test_num);
        reset_dut();

        wr = 1; wr_data = 8'hA1;
        @(posedge clk);
        wr_data = 8'hB2;
        @(posedge clk);

        wr = 0; rd = 1;
        @(posedge clk);

        rd = 1;
        @(posedge clk);
        #1;
        rd = 0;

        #1;


        check_outputs(1, 0, 1, 0, 8'hxx);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Overflow protection", test_num);
        reset_dut();
        wr = 1; wr_data = 8'h01;
        @(posedge clk);
        wr_data = 8'h02;
        @(posedge clk);
        wr_data = 8'h03;
        @(posedge clk);
        #1;
        wr = 0;

        #1;


        check_outputs(0, 1, 0, 1, 8'h01);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Underflow protection", test_num);
        reset_dut();
        rd = 1;
        @(posedge clk);
        #1;
        rd = 0;

        #1;


        check_outputs(1, 0, 1, 0, 8'hxx);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Simultaneous Write and Read", test_num);
        reset_dut();

        wr = 1; wr_data = 8'hD1;
        @(posedge clk);

        wr = 1; wr_data = 8'hD2; rd = 1;
        @(posedge clk);
        #1;
        wr = 0; rd = 0;

        #1;


        check_outputs(1, 1, 0, 0, 8'hD2);
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
        input expected_almost_empty;
        input expected_almost_full;
        input expected_empty;
        input expected_full;
        input [7:0] expected_rd_data;
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
