`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    reg [7:0] wr_data;
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
        .en(en),
        .rst(rst),
        .wr_data(wr_data),
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
            rst = 1;
            en = 0;
            wr_data = 8'h00;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial state after reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single write operation", test_num);
            reset_dut();

            en = 1;
            wr_data = 8'hA5;
            @(posedge clk);
            en = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 8'hA5);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Fill FIFO to capacity", test_num);
            reset_dut();

            for (i = 0; i < 8; i = i + 1) begin
                en = 1;
                wr_data = 8'h10 + i;
                @(posedge clk);
            end
            en = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b1, 8'h10);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow condition", test_num);
            reset_dut();


            for (i = 0; i < 12; i = i + 1) begin
                en = 1;
                wr_data = i + 1;
                @(posedge clk);
            end
            en = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b1, 8'h01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Partial fill data integrity", test_num);
            reset_dut();

            en = 1; wr_data = 8'hDE; @(posedge clk);
            en = 1; wr_data = 8'hAD; @(posedge clk);
            en = 1; wr_data = 8'hBE; @(posedge clk);
            en = 1; wr_data = 8'hEF; @(posedge clk);
            en = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 1'b0, 8'hDE);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset while full", test_num);
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                en = 1;
                wr_data = i;
                @(posedge clk);
            end


            reset_dut();


            #1;



            check_outputs(1'b1, 1'b0, 8'h00);
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
        input [7:0] expected_rd_data;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_rd_data === (expected_rd_data ^ rd_data ^ expected_rd_data)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, rd_data=%h",
                         empty, full, rd_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, rd_data=%h",
                         expected_empty, expected_full, expected_rd_data);
                $display("  Got:      empty=%b, full=%b, rd_data=%h",
                         empty, full, rd_data);
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
        $dumpvars(0,clk, en, rst, wr_data, empty, full, rd_data);
    end

endmodule
