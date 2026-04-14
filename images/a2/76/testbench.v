`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg rd;
    reg reset;
    reg wr;
    wire [3:0] count;
    wire [7:0] dout;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .rd(rd),
        .reset(reset),
        .wr(wr),
        .count(count),
        .dout(dout),
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
            reset = 1;
            rd = 0;
            wr = 0;
            din = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial state after reset");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'd0, 8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single write then single read");
            test_num = 2;
            reset_dut();


            wr = 1; din = 8'hAA;
            @(posedge clk);
            #1 wr = 0;


            rd = 1;
            @(posedge clk);
            #1 rd = 0;


            #1;



            check_outputs(4'd0, 8'hAA, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: Fill FIFO to capacity (8 elements)");
            test_num = 3;
            reset_dut();

            for (i = 1; i <= 8; i = i + 1) begin
                wr = 1; din = i;
                @(posedge clk);
            end
            #1 wr = 0;


            #1;



            check_outputs(4'd8, 8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Fill then empty FIFO");
            test_num = 4;
            reset_dut();


            for (i = 1; i <= 8; i = i + 1) begin
                wr = 1; din = i;
                @(posedge clk);
            end
            #1 wr = 0;


            for (i = 1; i <= 8; i = i + 1) begin
                rd = 1;
                @(posedge clk);
            end
            #1 rd = 0;


            #1;



            check_outputs(4'd0, 8'h08, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Testcase 005: Write 10 items into 8-item FIFO (Overflow check)");
            test_num = 5;
            reset_dut();


            for (i = 1; i <= 10; i = i + 1) begin
                wr = 1; din = i;
                @(posedge clk);
            end
            #1 wr = 0;


            #1;



            check_outputs(4'd8, 8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Read from empty FIFO (Underflow check)");
            test_num = 6;
            reset_dut();


            rd = 1;
            @(posedge clk);
            @(posedge clk);
            #1 rd = 0;


            #1;



            check_outputs(4'd0, 8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            $display("Testcase 007: Test pointer wrap-around");
            test_num = 7;
            reset_dut();


            for (i = 1; i <= 5; i = i + 1) begin
                wr = 1; din = i;
                @(posedge clk);
            end
            #1 wr = 0;


            for (i = 1; i <= 5; i = i + 1) begin
                rd = 1;
                @(posedge clk);
            end
            #1 rd = 0;


            for (i = 10; i <= 14; i = i + 1) begin
                wr = 1; din = i;
                @(posedge clk);
            end
            #1 wr = 0;


            rd = 1;
            @(posedge clk);
            #1 rd = 0;


            #1;



            check_outputs(4'd4, 8'd10, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Simultaneous Write and Read");
            test_num = 8;
            reset_dut();


            wr = 1; din = 8'h55;
            @(posedge clk);
            #1 wr = 0;



            wr = 1; din = 8'h66; rd = 1;
            @(posedge clk);
            #1 wr = 0; rd = 0;


            #1;



            check_outputs(4'd1, 8'h55, 1'b0, 1'b0);
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
        input [3:0] expected_count;
        input [7:0] expected_dout;
        input expected_empty;
        input expected_full;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: count=%h, dout=%h, empty=%b, full=%b",
                         count, dout, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, dout=%h, empty=%b, full=%b",
                         expected_count, expected_dout, expected_empty, expected_full);
                $display("  Got:      count=%h, dout=%h, empty=%b, full=%b",
                         count, dout, empty, full);
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
        $dumpvars(0,clk, din, rd, reset, wr, count, dout, empty, full);
    end

endmodule
