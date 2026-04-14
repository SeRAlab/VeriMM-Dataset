`timescale 1ns/1ps

module DFS_BinaryTree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] node_value;
    reg reset;
    reg start;
    wire [7:0] dfs_output;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DFS_BinaryTree dut (
        .clk(clk),
        .node_value(node_value),
        .reset(reset),
        .start(start),
        .dfs_output(dfs_output),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            node_value = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Standard Full Binary Tree Traversal", test_num);
            reset_dut();
            node_value = 8'h01;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            repeat(1) @(posedge clk);
            #1;

            check_outputs(8'h07, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Node Tree", test_num);
            reset_dut();
            node_value = 8'h0A;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            repeat(1) @(posedge clk);
            #1;

            check_outputs(8'h0A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Left-Skewed Tree Traversal", test_num);
            reset_dut();
            node_value = 8'h20;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            repeat(1) @(posedge clk);
            #1;

            check_outputs(8'h22, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Right-Skewed Tree Traversal", test_num);
            reset_dut();
            node_value = 8'h30;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            repeat(1) @(posedge clk);
            #1;

            check_outputs(8'h35, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: System Reset and Re-trigger Test", test_num);
            reset_dut();
            node_value = 8'hFF;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            #20;
            reset_dut();
            node_value = 8'h01;
            start = 1;
            @(posedge clk);
            start = 0;
            wait(done == 1);
            repeat(1) @(posedge clk);
            #1;

            check_outputs(8'h07, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DFS_BinaryTree Testbench");
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
        input [7:0] expected_dfs_output;
        input expected_done;
        begin
            if (expected_dfs_output === (expected_dfs_output ^ dfs_output ^ expected_dfs_output) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: dfs_output=%h, done=%b",
                         dfs_output, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dfs_output=%h, done=%b",
                         expected_dfs_output, expected_done);
                $display("  Got:      dfs_output=%h, done=%b",
                         dfs_output, done);
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
        $dumpvars(0,clk, node_value, reset, start, dfs_output, done);
    end

endmodule
