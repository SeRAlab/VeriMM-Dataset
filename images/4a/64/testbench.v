`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [15:0] fifo_in;
    reg read;
    reg reset;
    reg write;
    wire fifo_empty;
    wire fifo_full;
    wire [15:0] fifo_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .fifo_in(fifo_in),
        .read(read),
        .reset(reset),
        .write(write),
        .fifo_empty(fifo_empty),
        .fifo_full(fifo_full),
        .fifo_out(fifo_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            read = 0;
            write = 0;
            fifo_in = 0;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task push;

        input [15:0] data;
        begin
            @(posedge clock);
            #1;
            fifo_in = data;
            write = 1;
            @(posedge clock);
            #1;
            write = 0;
            fifo_in = 0;
        end
        endtask

    task pop;

        begin
            @(posedge clock);
            #1;
            read = 1;
            @(posedge clock);
            #1;
            read = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Write/Read Check", test_num);
            reset_dut();
            push(16'hAAAA);
            pop();


            #1;



            check_outputs(1'b1, 1'b0, 16'hAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Multi-Data FIFO Logic Check", test_num);
            reset_dut();
            push(16'h1111);
            push(16'h2222);
            push(16'h3333);
            pop();
            pop();
            pop();
            #1;

            check_outputs(1'b1, 1'b0, 16'h3333);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %03d: Full Flag Check", test_num);
            reset_dut();

            for (i = 0; i < 32; i = i + 1) begin
                if (!fifo_full) push(i[15:0]);
            end
            #1;

            check_outputs(1'b0, 1'b1, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Empty Flag Underflow Check", test_num);
            reset_dut();
            pop();
            pop();
            #1;

            check_outputs(1'b1, 1'b0, 16'h0000);
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
        input expected_fifo_empty;
        input expected_fifo_full;
        input [15:0] expected_fifo_out;
        begin
            if (expected_fifo_empty === (expected_fifo_empty ^ fifo_empty ^ expected_fifo_empty) &&
                expected_fifo_full === (expected_fifo_full ^ fifo_full ^ expected_fifo_full) &&
                expected_fifo_out === (expected_fifo_out ^ fifo_out ^ expected_fifo_out)) begin
                $display("PASS");
                $display("  Outputs: fifo_empty=%b, fifo_full=%b, fifo_out=%h",
                         fifo_empty, fifo_full, fifo_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fifo_empty=%b, fifo_full=%b, fifo_out=%h",
                         expected_fifo_empty, expected_fifo_full, expected_fifo_out);
                $display("  Got:      fifo_empty=%b, fifo_full=%b, fifo_out=%h",
                         fifo_empty, fifo_full, fifo_out);
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
        $dumpvars(0,clock, fifo_in, read, reset, write, fifo_empty, fifo_full, fifo_out);
    end

endmodule
