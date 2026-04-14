`timescale 1ns/1ps

module bfs_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] adj_matrix;
    reg clk;
    reg rst;
    reg [3:0] start_node;
    wire done;
    wire [3:0] visited_nodes;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bfs dut (
        .adj_matrix(adj_matrix),
        .clk(clk),
        .rst(rst),
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
            adj_matrix = 16'h0000;
            start_node = 4'd0;
            repeat(2) @(posedge clk);
            #1 rst = 0;

            while (done === 1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Linear Chain 0->1->2->3, Start at Node 0", test_num);
            reset_dut();
            adj_matrix = 16'h0842;
            start_node = 4'd0;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'b1111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Disconnected Components {0,1} {2,3}, Start at Node 0", test_num);
            reset_dut();
            adj_matrix = 16'h0802;
            start_node = 4'd0;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'b0011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Star Graph (0 points to all), Start at Node 0", test_num);
            reset_dut();
            adj_matrix = 16'h000E;
            start_node = 4'd0;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Circular Graph 0->1->2->0, Start at Node 1", test_num);
            reset_dut();
            adj_matrix = 16'h0142;
            start_node = 4'd1;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'b0111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Fully Connected Graph, Start at Node 3", test_num);
            reset_dut();
            adj_matrix = 16'hFFFF;
            start_node = 4'd3;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Isolated Node, Start at Node 2", test_num);
            reset_dut();
            adj_matrix = 16'h0000;
            start_node = 4'd2;

            wait(done == 1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'b0100);
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
        input expected_done;
        input [3:0] expected_visited_nodes;
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
        $dumpvars(0,adj_matrix, clk, rst, start_node, done, visited_nodes);
    end

endmodule
