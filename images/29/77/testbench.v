`timescale 1ns/1ps

module merge_sort_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg rst;
    reg start;
    wire [31:0] data_out;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    merge_sort dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .start(start),
        .data_out(data_out),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            data_in = 0;
            repeat(2) @(posedge clk);
            #1;
            rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Unsorted Array", test_num);
            reset_dut();
            data_in = 32'h4A2F1C53;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(32'hFCA54321, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Already Sorted Array", test_num);
            reset_dut();
            data_in = 32'h87654321;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(32'h87654321, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reverse Sorted Array", test_num);
            reset_dut();
            data_in = 32'h12345678;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(32'h87654321, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Array with Duplicates", test_num);
            reset_dut();
            data_in = 32'h44221133;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(32'h44332211, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Elements Identical", test_num);
            reset_dut();
            data_in = 32'hAAAAAAAA;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(32'hAAAAAAAA, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Extremes (0 and F)", test_num);
            reset_dut();
            data_in = 32'hF0F00F0F;
            start = 1;
            @(posedge clk);
            #1;
            start = 0;
            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(32'hFFFF0000, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("merge_sort Testbench");
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
        input [31:0] expected_data_out;
        input expected_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b",
                         data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b",
                         expected_data_out, expected_done);
                $display("  Got:      data_out=%h, done=%b",
                         data_out, done);
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
        $dumpvars(0,clk, data_in, rst, start, data_out, done);
    end

endmodule
