`timescale 1ns/1ps

module bfs_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg start;
    reg [3:0] start_node;
    wire done;
    wire [15:0] visited_nodes;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bfs dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .start_node(start_node),
        .done(done),
        .visited_nodes(visited_nodes)
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
            start_node = 4'd0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Starting BFS from Node 0", test_num);
            reset_dut();

            start_node = 4'd0;
            start = 1;
            #10;
            start = 0;


            wait(done == 1'b1);
            #10;



            #1;




            check_outputs(1'b1, 16'h0007);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Starting BFS from Node 5", test_num);
            reset_dut();

            start_node = 4'd5;
            start = 1;
            #10;
            start = 0;

            wait(done == 1'b1);
            #10;


            #1;



            check_outputs(1'b1, 16'h0020);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Starting BFS from Node 15", test_num);
            reset_dut();

            start_node = 4'd15;
            start = 1;
            #10;
            start = 0;

            wait(done == 1'b1);
            #10;


            #1;



            check_outputs(1'b1, 16'h8000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Consecutive Run (Node 1 followed by Node 2)", test_num);


            reset_dut();
            start_node = 4'd1;
            start = 1; #10; start = 0;
            wait(done == 1'b1);
            #10;


            reset_dut();
            start_node = 4'd2;
            start = 1; #10; start = 0;
            wait(done == 1'b1);
            #10;


            #1;



            check_outputs(1'b1, 16'h0004);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset during BFS operation", test_num);
            reset_dut();

            start_node = 4'd0;
            start = 1;
            #10;
            start = 0;


            #30;
            rst = 1;
            #20;
            rst = 0;


            if (done == 1'b0 && visited_nodes == 16'h0000) begin
                $display("PASS: Circuit cleared correctly during operation");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Circuit failed to clear state on mid-op reset");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bfs Testbench");
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
        input expected_done;
        input [15:0] expected_visited_nodes;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_visited_nodes === (expected_visited_nodes ^ visited_nodes ^ expected_visited_nodes)) begin
                $display("PASS");
                $display("  Outputs: done=%b, visited_nodes=%h",
                         done, visited_nodes);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, visited_nodes=%h",
                         expected_done, expected_visited_nodes);
                $display("  Got:      done=%b, visited_nodes=%h",
                         done, visited_nodes);
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
        $dumpvars(0,clk, rst, start, start_node, done, visited_nodes);
    end

endmodule
