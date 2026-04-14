`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg read;
    reg reset;
    reg write;
    wire [7:0] data_out;
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
        .read(read),
        .reset(reset),
        .write(write),
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
            write = 0;
            read = 0;
            data_in = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task wait_clk;

        @(posedge clk);
        #1;
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Write Flags", test_num);
            reset_dut();
            wait_clk();
            data_in = 8'hA5;
            write = 1;
            wait_clk();
            write = 0;

            #1;


            check_outputs(data_out, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Write and Read back 1 byte", test_num);
            reset_dut();
            wait_clk();
            data_in = 8'h5A;
            write = 1;
            wait_clk();
            write = 0;
            read = 1;
            wait_clk();
            read = 0;

            #1;


            check_outputs(8'h5A, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %03d: Fill to Full (16 bytes)", test_num);
            reset_dut();
            for (i = 0; i < 16; i = i + 1) begin
                wait_clk();
                data_in = i + 1;
                write = 1;
            end
            wait_clk();
            write = 0;

            #1;


            check_outputs(data_out, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %03d: Read all back from full", test_num);
            reset_dut();

            for (i = 1; i <= 16; i = i + 1) begin
                wait_clk();
                data_in = i;
                write = 1;
            end
            wait_clk();
            write = 0;

            for (i = 1; i <= 16; i = i + 1) begin
                read = 1;
                wait_clk();
            end
            read = 0;

            #1;


            check_outputs(8'h10, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %03d: Overflow Check", test_num);
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                wait_clk();
                data_in = i;
                write = 1;
            end
            wait_clk();

            data_in = 8'hFF;
            write = 1;
            wait_clk();
            write = 0;

            #1;


            check_outputs(data_out, 1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Concurrent Read and Write", test_num);
            reset_dut();

            wait_clk();
            data_in = 8'h11;
            write = 1;
            wait_clk();

            data_in = 8'h22;
            write = 1;
            read = 1;
            wait_clk();
            write = 0;
            read = 0;

            #1;


            check_outputs(8'h11, 1'b0, 1'b0);
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, read, reset, write, data_out, empty, full);
    end

endmodule
