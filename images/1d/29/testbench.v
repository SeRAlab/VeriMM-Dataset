`timescale 1ns/1ps

module bfs_traversal_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] adj_matrix;
    reg clk;
    reg [1:0] start_node;
    wire [15:0] traverse_order;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bfs_traversal dut (
        .adj_matrix(adj_matrix),
        .clk(clk),
        .start_node(start_node),
        .traverse_order(traverse_order)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            adj_matrix = 16'h0000;
            start_node = 2'b00;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Linear Path 0->1->2->3", test_num);
            adj_matrix = 16'h0842;
            start_node = 2'd0;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(16'h3210);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Star Graph from Node 0", test_num);
            adj_matrix = 16'h000E;
            start_node = 2'd0;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(16'h3210);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Disconnected Graph (0-1, 2-3)", test_num);
            adj_matrix = 16'h0802;
            start_node = 2'd0;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(16'hFF10);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Cyclic Graph starting at Node 1", test_num);
            adj_matrix = 16'h0854;
            start_node = 2'd1;
            repeat (10) @(posedge clk);

            #1;


            check_outputs(16'h3201);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Completely Isolated Node", test_num);
            adj_matrix = 16'h0000;
            start_node = 2'd2;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(16'hFFF2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bfs_traversal Testbench");
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
        input [15:0] expected_traverse_order;
        begin
            if (expected_traverse_order === (expected_traverse_order ^ traverse_order ^ expected_traverse_order)) begin
                $display("PASS");
                $display("  Outputs: traverse_order=%h",
                         traverse_order);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: traverse_order=%h",
                         expected_traverse_order);
                $display("  Got:      traverse_order=%h",
                         traverse_order);
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
        $dumpvars(0,adj_matrix, clk, start_node, traverse_order);
    end

endmodule
