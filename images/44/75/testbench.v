`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] item_in;
    reg read;
    reg reset;
    reg write;
    wire empty;
    wire full;
    wire [1:0] item_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .item_in(item_in),
        .read(read),
        .reset(reset),
        .write(write),
        .empty(empty),
        .full(full),
        .item_out(item_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            write = 0;
            read = 0;
            item_in = 2'b00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            $display("Testcase %0d: Checking initial state", test_num);
            #1;

            check_outputs(1'b1, 1'b0, item_out);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            item_in = 2'b11;
            write = 1;
            @(posedge clk);
            #1 write = 0;
            @(posedge clk);
            #1;

            $display("Testcase %0d: Single write 2'b11", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            item_in = 2'b00; write = 1; @(posedge clk);
            #1 item_in = 2'b01; write = 1; @(posedge clk);
            #1 item_in = 2'b10; write = 1; @(posedge clk);
            #1 item_in = 2'b11; write = 1; @(posedge clk);
            #1 write = 0;
            @(posedge clk);
            #1;

            $display("Testcase %0d: Fill FIFO to capacity", test_num);
            #1;

            check_outputs(1'b0, 1'b1, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            item_in = 2'b10; write = 1; @(posedge clk);
            #1 item_in = 2'b01; write = 1; @(posedge clk);
            #1 write = 0;

            read = 1; @(posedge clk);
            #1 read = 1; @(posedge clk);
            #1 read = 0;
            @(posedge clk);
            #1;

            $display("Testcase %0d: Fill 2 and Empty 2", test_num);
            #1;

            check_outputs(1'b1, 1'b0, item_out);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            item_in = 2'b01; write = 1; @(posedge clk);
            #1 write = 0; @(posedge clk);
            #1;

            read = 1;
            item_in = 2'b11;
            write = 1;
            @(posedge clk);
            #1 read = 0; write = 0;
            @(posedge clk);
            #1;

            $display("Testcase %0d: Simultaneous Read/Write", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            item_in = 2'b00; write = 1; @(posedge clk);
            #1 item_in = 2'b01; write = 1; @(posedge clk);
            #1 item_in = 2'b10; write = 1; @(posedge clk);
            #1 write = 0; read = 1; @(posedge clk);
            #1 read = 1; @(posedge clk);
            #1 read = 1; @(posedge clk);
            #1 read = 0;

            item_in = 2'b11; write = 1; @(posedge clk);
            #1 write = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Wrap-around logic test", test_num);
            #1;

            check_outputs(1'b0, 1'b0, 2'b11);
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
        input [1:0] expected_item_out;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_item_out === (expected_item_out ^ item_out ^ expected_item_out)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, item_out=%h",
                         empty, full, item_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, item_out=%h",
                         expected_empty, expected_full, expected_item_out);
                $display("  Got:      empty=%b, full=%b, item_out=%h",
                         empty, full, item_out);
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
        $dumpvars(0,clk, item_in, read, reset, write, empty, full, item_out);
    end

endmodule
