`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] datain;
    reg rd;
    reg rst;
    reg wr;
    wire [7:0] dataout;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .datain(datain),
        .rd(rd),
        .rst(rst),
        .wr(wr),
        .dataout(dataout),
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
            rst = 1;
            wr = 0;
            rd = 0;
            datain = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset State");
            reset_dut();

            #1;


            check_outputs(dataout, 1, 0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Write/Read");
            reset_dut();

            @(negedge clk);
            datain = 8'hA5;
            wr = 1;
            @(negedge clk);
            wr = 0;

            rd = 1;
            @(negedge clk);
            rd = 0;

            #1;


            check_outputs(8'hA5, 1, 0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: Fill to Capacity");
            reset_dut();
            @(negedge clk);
            wr = 1;
            for (i = 0; i < 16; i = i + 1) begin
                datain = i + 1;
                @(negedge clk);
            end
            wr = 0;

            #1;


            check_outputs(8'h01, 0, 1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Fill and Empty");
            reset_dut();

            @(negedge clk);
            wr = 1;
            for (i = 0; i < 16; i = i + 1) begin
                datain = i + 10;
                @(negedge clk);
            end
            wr = 0;

            rd = 1;
            for (i = 0; i < 16; i = i + 1) begin
                @(negedge clk);
            end
            rd = 0;

            #1;


            check_outputs(8'd25, 1, 0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Testcase 005: Overflow Handling");
            reset_dut();
            @(negedge clk);
            wr = 1;

            for (i = 0; i < 20; i = i + 1) begin
                datain = i;
                @(negedge clk);
            end
            wr = 0;

            rd = 1;
            @(negedge clk);
            rd = 0;

            #1;


            check_outputs(8'h00, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Underflow Handling");
            reset_dut();
            @(negedge clk);
            rd = 1;
            repeat(5) @(negedge clk);
            rd = 0;

            #1;


            check_outputs(dataout, 1, 0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Simultaneous Read/Write");
            reset_dut();

            @(negedge clk);
            datain = 8'hCC;
            wr = 1;
            @(negedge clk);

            datain = 8'hDD;
            wr = 1;
            rd = 1;
            @(negedge clk);
            wr = 0;
            rd = 0;


            #1;



            check_outputs(8'hCC, 0, 0);
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
        input [7:0] expected_dataout;
        input expected_empty;
        input expected_full;
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h, empty=%b, full=%b",
                         dataout, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h, empty=%b, full=%b",
                         expected_dataout, expected_empty, expected_full);
                $display("  Got:      dataout=%h, empty=%b, full=%b",
                         dataout, empty, full);
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
        $dumpvars(0,clk, datain, rd, rst, wr, dataout, empty, full);
    end

endmodule
