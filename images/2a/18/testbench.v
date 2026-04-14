`timescale 1ns/1ps

module DFS_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] adj_matrix;
    reg clk;
    reg rst;
    reg [3:0] start_node;
    wire [15:0] visited_nodes;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DFS dut (
        .adj_matrix(adj_matrix),
        .clk(clk),
        .rst(rst),
        .start_node(start_node),
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
            adj_matrix = 0;
            start_node = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            adj_matrix = 16'h0000;
            start_node = 4'd0;
            repeat(10) @(posedge clk);
            $display("Test %0d: Isolated Node (Start at 0)", test_num);
            #1;

            check_outputs(16'hFFF0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            adj_matrix = 16'h4210;
            start_node = 4'd0;
            repeat(20) @(posedge clk);
            $display("Test %0d: Linear Path 0->1->2->3", test_num);
            #1;

            check_outputs(16'h3210);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            adj_matrix = 16'h6000;
            start_node = 4'd0;
            repeat(20) @(posedge clk);
            $display("Test %0d: Branching Path 0->1, 0->2", test_num);

            #1;


            check_outputs(16'hFF210);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            adj_matrix = 16'h4280;
            start_node = 4'd0;
            repeat(20) @(posedge clk);
            $display("Test %0d: Cyclic Graph 0->1->2->0", test_num);
            #1;

            check_outputs(16'hFF210);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            adj_matrix = 16'h4812;
            start_node = 4'd2;
            repeat(20) @(posedge clk);
            $display("Test %0d: Disconnected Components (Start at 2)", test_num);
            #1;

            check_outputs(16'hFF32);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DFS Testbench");
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
        input [15:0] expected_visited_nodes;
        begin
            if (expected_visited_nodes === (expected_visited_nodes ^ visited_nodes ^ expected_visited_nodes)) begin
                $display("PASS");
                $display("  Outputs: visited_nodes=%h",
                         visited_nodes);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: visited_nodes=%h",
                         expected_visited_nodes);
                $display("  Got:      visited_nodes=%h",
                         visited_nodes);
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
        $dumpvars(0,adj_matrix, clk, rst, start_node, visited_nodes);
    end

endmodule
