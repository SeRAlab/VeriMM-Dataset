`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] din;
    reg read;
    reg rst;
    reg write;
    wire [15:0] dout;
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
        .read(read),
        .rst(rst),
        .write(write),
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
            rst = 1;
            din = 0;
            write = 0;
            read = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Verifying Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(dout, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Write and Read Transaction", test_num);
            reset_dut();


            @(posedge clk);
            din = 16'hABCD;
            write = 1;
            @(posedge clk);
            write = 0;
            #1;


            @(posedge clk);
            read = 1;
            @(posedge clk);
            read = 0;
            #1;


            #1;



            check_outputs(16'hABCD, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %03d: Filling FIFO to Capacity (8 entries)", test_num);
            reset_dut();

            for (i = 1; i <= 8; i = i + 1) begin
                @(posedge clk);
                din = i;
                write = 1;
            end
            @(posedge clk);
            write = 0;
            #1;


            #1;



            check_outputs(16'h0001, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %03d: Fill and then Empty FIFO", test_num);
            reset_dut();


            for (i = 1; i <= 8; i = i + 1) begin
                @(posedge clk);
                din = 16'hF000 | i;
                write = 1;
            end
            @(posedge clk);
            write = 0;


            for (i = 1; i <= 8; i = i + 1) begin
                @(posedge clk);
                read = 1;
            end
            @(posedge clk);
            read = 0;
            #1;


            #1;



            check_outputs(16'hF008, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %03d: Overflow condition (Writing 9 items into 8-deep FIFO)", test_num);
            reset_dut();


            for (i = 1; i <= 9; i = i + 1) begin
                @(posedge clk);
                din = i;
                write = 1;
            end
            @(posedge clk);
            write = 0;
            #1;


            #1;



            check_outputs(16'h0001, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Simultaneous Read and Write", test_num);
            reset_dut();


            @(posedge clk);
            din = 16'hAAAA;
            write = 1;
            @(posedge clk);
            write = 0;


            @(posedge clk);
            read = 1;
            write = 1;
            din = 16'hBBBB;
            @(posedge clk);
            read = 0;
            write = 0;
            #1;



            #1;




            check_outputs(16'hBBBB, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("Testcase %03d: Pointer Wrap-around", test_num);
            reset_dut();


            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
                write = 1; din = i;
            end
            @(posedge clk);
            write = 0;
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
                read = 1;
            end
            @(posedge clk);
            read = 0;


            for (i = 1; i <= 8; i = i + 1) begin
                @(posedge clk);
                write = 1; din = 16'hCC00 | i;
            end
            @(posedge clk);
            write = 0;
            #1;


            #1;



            check_outputs(16'hCC01, 1'b0, 1'b1);
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
        input [15:0] expected_dout;
        input expected_empty;
        input expected_full;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, empty=%b, full=%b",
                         dout, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, empty=%b, full=%b",
                         expected_dout, expected_empty, expected_full);
                $display("  Got:      dout=%h, empty=%b, full=%b",
                         dout, empty, full);
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
        $dumpvars(0,clk, din, read, rst, write, dout, empty, full);
    end

endmodule
