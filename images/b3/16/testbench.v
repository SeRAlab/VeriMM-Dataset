`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rd;
    reg reset_n;
    reg wr;
    reg [43:0] wr_data;
    wire almost_empty;
    wire almost_full;
    wire empty;
    wire full;
    wire [43:0] rd_data;

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
            wr_data = 44'h0;
            reset_n = 0;
            repeat(2) @(posedge clk);
            #1;
            reset_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 44'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Single Write Operation", test_num);
            reset_dut();
            wr = 1;
            wr_data = 44'h111_2222_3333;
            @(posedge clk);
            #1;
            wr = 0;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 1'b0, 44'h111_2222_3333);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Fill FIFO (2 entries)", test_num);
            reset_dut();

            wr = 1; wr_data = 44'hAAA_AAAA_AAAA;
            @(posedge clk); #1;

            wr = 1; wr_data = 44'hBBB_BBBB_BBBB;
            @(posedge clk); #1;
            wr = 0;


            #1;



            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 44'hAAA_AAAA_AAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Write Two, Read One", test_num);
            reset_dut();

            wr = 1; wr_data = 44'hAAA_AAAA_AAAA;
            @(posedge clk); #1;

            wr = 1; wr_data = 44'hBBB_BBBB_BBBB;
            @(posedge clk); #1;
            wr = 0;

            rd = 1;
            @(posedge clk); #1;
            rd = 0;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 1'b0, 44'hBBB_BBBB_BBBB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Simultaneous Read/Write at Count 1", test_num);
            reset_dut();

            wr = 1; wr_data = 44'hAAA_AAAA_AAAA;
            @(posedge clk); #1;

            wr = 1; wr_data = 44'hBBB_BBBB_BBBB;
            rd = 1;
            @(posedge clk); #1;
            wr = 0; rd = 0;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 1'b0, 44'hBBB_BBBB_BBBB);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Overflow Protection Check", test_num);
            reset_dut();

            wr = 1; wr_data = 44'h111_1111_1111; @(posedge clk); #1;
            wr = 1; wr_data = 44'h222_2222_2222; @(posedge clk); #1;
            wr = 1; wr_data = 44'h333_3333_3333; @(posedge clk); #1;
            wr = 0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 44'h111_1111_1111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Underflow Protection Check", test_num);
            reset_dut();

            wr = 1; wr_data = 44'hAAA_AAAA_AAAA; @(posedge clk); #1;
            wr = 0;
            rd = 1; @(posedge clk); #1;
            rd = 1; @(posedge clk); #1;
            rd = 0;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 44'hAAA_AAAA_AAAA);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Read Until Empty", test_num);
            reset_dut();
            wr = 1; wr_data = 44'h101_1010_1010; @(posedge clk); #1;
            wr = 0; rd = 1; @(posedge clk); #1;
            rd = 0;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 44'h101_1010_1010);
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
        input [43:0] expected_rd_data;
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
