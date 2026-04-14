`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [31:0] data_in;
    reg read;
    reg reset;
    reg write;
    wire almost_empty;
    wire almost_full;
    wire [31:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .data_in(data_in),
        .read(read),
        .reset(reset),
        .write(write),
        .almost_empty(almost_empty),
        .almost_full(almost_full),
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
            reset = 1;
            clear = 0;
            write = 0;
            read = 0;
            data_in = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 0, 32'h0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            write = 1;
            data_in = 32'hAAAA_BBBB;
            @(posedge clk);
            write = 0;
            @(posedge clk);

            #1;


            check_outputs(1, 0, 32'h0, 0, 0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            reset_dut();
            write = 1;
            for (i = 0; i < 7; i = i + 1) begin
                data_in = i + 1;
                @(posedge clk);
            end
            write = 0;
            @(posedge clk);

            #1;


            check_outputs(0, 1, 32'h0, 0, 0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            write = 1;
            for (i = 0; i < 8; i = i + 1) begin
                data_in = i + 1;
                @(posedge clk);
            end
            write = 0;
            @(posedge clk);

            #1;


            check_outputs(0, 0, 32'h0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge clk);
            write = 1; data_in = 32'h1111_1111; @(posedge clk);
            write = 1; data_in = 32'h2222_2222; @(posedge clk);
            write = 0;
            read = 1; @(posedge clk);
            read = 0;
            @(posedge clk);

            #1;


            check_outputs(1, 0, 32'h1111_1111, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            write = 1; data_in = 32'hFFFF_FFFF; @(posedge clk);
            write = 1; data_in = 32'hEEEE_EEEE; @(posedge clk);
            write = 0;
            @(posedge clk);
            clear = 1;
            @(posedge clk);
            clear = 0;
            @(posedge clk);

            #1;


            check_outputs(0, 0, 32'h0, 1, 0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            reset_dut();

            write = 1;
            for (i = 0; i < 8; i = i + 1) begin
                data_in = i + 10;
                @(posedge clk);
            end
            write = 0;

            read = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
            end
            read = 0;
            @(posedge clk);

            #1;


            check_outputs(0, 0, 32'd17, 1, 0);
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
        input expected_almost_empty;
        input expected_almost_full;
        input [31:0] expected_data_out;
        input expected_empty;
        input expected_full;
        begin
            if (expected_almost_empty === (expected_almost_empty ^ almost_empty ^ expected_almost_empty) &&
                expected_almost_full === (expected_almost_full ^ almost_full ^ expected_almost_full) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: almost_empty=%b, almost_full=%b, data_out=%h, empty=%b, full=%b",
                         almost_empty, almost_full, data_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: almost_empty=%b, almost_full=%b, data_out=%h, empty=%b, full=%b",
                         expected_almost_empty, expected_almost_full, expected_data_out, expected_empty, expected_full);
                $display("  Got:      almost_empty=%b, almost_full=%b, data_out=%h, empty=%b, full=%b",
                         almost_empty, almost_full, data_out, empty, full);
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
        $dumpvars(0,clear, clk, data_in, read, reset, write, almost_empty, almost_full, data_out, empty, full);
    end

endmodule
