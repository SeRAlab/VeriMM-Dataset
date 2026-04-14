`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg rd_en;
    reg rst_n;
    reg wr_en;
    wire [31:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rd_en(rd_en),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            wr_en = 0;
            rd_en = 0;
            data_in = 0;
            repeat(5) @(posedge clk);
            #1 rst_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset State...");
            reset_dut();


            #1;



            check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Write/Read...");
            reset_dut();


            @(posedge clk);
            #1 wr_en = 1; data_in = 32'hAAAA5555;
            @(posedge clk);
            #1 wr_en = 0;


            @(posedge clk);
            #1 rd_en = 1;
            @(posedge clk);
            #1 rd_en = 0;


            #1;



            check_outputs(32'hAAAA5555, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running testcase003: Fill to Full (Depth 1024)...");
            reset_dut();

            @(posedge clk);
            #1 wr_en = 1;
            for (i = 0; i < 1024; i = i + 1) begin
                data_in = i;
                @(posedge clk);
            end
            #1 wr_en = 0;


            #1;



            check_outputs(data_out, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running testcase004: Empty from Full...");
            reset_dut();


            @(posedge clk);
            #1 wr_en = 1;
            for (i = 0; i < 1024; i = i + 1) begin
                data_in = i + 100;
                @(posedge clk);
            end
            #1 wr_en = 0;


            @(posedge clk);
            #1 rd_en = 1;
            for (i = 0; i < 1024; i = i + 1) begin
                @(posedge clk);
            end
            #1 rd_en = 0;


            #1;



            check_outputs(1023 + 100, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Running testcase005: Simultaneous Read/Write...");
            reset_dut();


            @(posedge clk);
            #1 wr_en = 1;
            for (i = 0; i < 512; i = i + 1) begin
                data_in = i;
                @(posedge clk);
            end


            #1 rd_en = 1;
            for (i = 0; i < 100; i = i + 1) begin
                data_in = i + 2000;
                @(posedge clk);
            end
            #1 wr_en = 0; rd_en = 0;


            #1;



            check_outputs(data_out, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Running testcase006: Pointer Wrap Around...");
            reset_dut();


            @(posedge clk);
            #1 wr_en = 1;
            for (i = 0; i < 1000; i = i + 1) begin
                data_in = i;
                @(posedge clk);
            end
            #1 wr_en = 0;


            @(posedge clk);
            #1 rd_en = 1;
            for (i = 0; i < 500; i = i + 1) begin
                @(posedge clk);
            end
            #1 rd_en = 0;


            @(posedge clk);
            #1 wr_en = 1;
            for (i = 0; i < 500; i = i + 1) begin
                data_in = i + 5000;
                @(posedge clk);
            end
            #1 wr_en = 0;


            #1;



            check_outputs(data_out, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Overflow/Underflow check...");
            reset_dut();


            @(posedge clk);
            #1 rd_en = 1;
            repeat(5) @(posedge clk);
            #1 rd_en = 0;


            if (empty !== 1'b1) $display("Underflow check failed");


            #1 wr_en = 1;
            for (integer i = 0; i < 1024; i = i + 1) begin
                data_in = 32'hFFFFFFFF;
                @(posedge clk);
            end


            data_in = 32'h12345678;
            repeat(5) @(posedge clk);
            #1 wr_en = 0;


            #1;



            check_outputs(32'hFFFFFFFF, 1'b0, 1'b1);
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
        input [31:0] expected_data_out;
        input expected_empty;
        input expected_full;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b, full=%b",
                         expected_data_out, expected_empty, expected_full);
                $display("  Got:      data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
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
        $dumpvars(0,clk, data_in, rd_en, rst_n, wr_en, data_out, empty, full);
    end

endmodule
