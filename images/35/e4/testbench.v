`timescale 1ns/1ps

module binary_heap_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg delete;
    reg insert;
    reg reset;
    wire [3:0] heap_size;
    wire [7:0] min_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_heap dut (
        .clk(clk),
        .data_in(data_in),
        .delete(delete),
        .insert(insert),
        .reset(reset),
        .heap_size(heap_size),
        .min_out(min_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'd0;
            insert = 0;
            delete = 0;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic single insertion", test_num);
            reset_dut();

            data_in = 8'd42;
            insert = 1;
            @(posedge clk);
            insert = 0;

            repeat(8) @(posedge clk);
            #1;

            check_outputs(4'd1, 8'd42);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Insert larger then smaller (Bubble Up)", test_num);
            reset_dut();


            data_in = 8'd50; insert = 1; @(posedge clk);
            insert = 0; repeat(4) @(posedge clk);


            data_in = 8'd20; insert = 1; @(posedge clk);
            insert = 0; repeat(8) @(posedge clk);

            #1;


            check_outputs(4'd2, 8'd20);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Multiple unordered insertions", test_num);
            reset_dut();


            data_in = 8'd30; insert = 1; @(posedge clk); insert = 0; repeat(4) @(posedge clk);
            data_in = 8'd10; insert = 1; @(posedge clk); insert = 0; repeat(4) @(posedge clk);
            data_in = 8'd40; insert = 1; @(posedge clk); insert = 0; repeat(4) @(posedge clk);
            data_in = 8'd5;  insert = 1; @(posedge clk); insert = 0; repeat(8) @(posedge clk);

            #1;


            check_outputs(4'd4, 8'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Delete minimum check", test_num);
            reset_dut();


            data_in = 8'd10; insert = 1; @(posedge clk); insert = 0; repeat(4) @(posedge clk);
            data_in = 8'd20; insert = 1; @(posedge clk); insert = 0; repeat(4) @(posedge clk);
            data_in = 8'd5;  insert = 1; @(posedge clk); insert = 0; repeat(4) @(posedge clk);


            delete = 1; @(posedge clk);
            delete = 0; repeat(8) @(posedge clk);

            #1;


            check_outputs(4'd2, 8'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Consecutive deletions", test_num);
            reset_dut();


            data_in = 8'd10; insert = 1; @(posedge clk); insert = 0; repeat(4) @(posedge clk);
            data_in = 8'd30; insert = 1; @(posedge clk); insert = 0; repeat(4) @(posedge clk);
            data_in = 8'd20; insert = 1; @(posedge clk); insert = 0; repeat(4) @(posedge clk);


            delete = 1; @(posedge clk); delete = 0; repeat(8) @(posedge clk);

            delete = 1; @(posedge clk); delete = 0; repeat(8) @(posedge clk);

            #1;


            check_outputs(4'd1, 8'd30);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Duplicate values check", test_num);
            reset_dut();

            data_in = 8'd15; insert = 1; @(posedge clk); insert = 0; repeat(4) @(posedge clk);
            data_in = 8'd5;  insert = 1; @(posedge clk); insert = 0; repeat(4) @(posedge clk);
            data_in = 8'd5;  insert = 1; @(posedge clk); insert = 0; repeat(8) @(posedge clk);

            #1;


            check_outputs(4'd3, 8'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Empty heap check", test_num);
            reset_dut();

            #1;


            check_outputs(4'd0, min_out);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_heap Testbench");
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
        input [3:0] expected_heap_size;
        input [7:0] expected_min_out;
        begin
            if (expected_heap_size === (expected_heap_size ^ heap_size ^ expected_heap_size) &&
                expected_min_out === (expected_min_out ^ min_out ^ expected_min_out)) begin
                $display("PASS");
                $display("  Outputs: heap_size=%h, min_out=%h",
                         heap_size, min_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: heap_size=%h, min_out=%h",
                         expected_heap_size, expected_min_out);
                $display("  Got:      heap_size=%h, min_out=%h",
                         heap_size, min_out);
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
        $dumpvars(0,clk, data_in, delete, insert, reset, heap_size, min_out);
    end

endmodule
