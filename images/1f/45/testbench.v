`timescale 1ns/1ps

module bfs_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] adj_matrix;
    reg clk;
    reg rst;
    reg [3:0] start_node;
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
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Disconnected Graph", test_num);
            adj_matrix = 16'h0000;
            start_node = 4'd0;
            @(posedge clk);
            #2 #1;
 check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Fully Connected Graph", test_num);
            adj_matrix = 16'hFFFF;
            start_node = 4'd1;
            @(posedge clk);
            #2 #1;
 check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Linear Path 0->1->2->3", test_num);
            adj_matrix = 16'h0842;
            start_node = 4'd0;
            @(posedge clk);
            #2 #1;
 check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Linear Path starting at Node 2", test_num);
            adj_matrix = 16'h0842;
            start_node = 4'd2;
            @(posedge clk);
            #2 #1;
 check_outputs(4'b1100);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Star Graph (Center 0)", test_num);
            adj_matrix = 16'h000E;
            start_node = 4'd0;
            @(posedge clk);
            #2 #1;
 check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Disconnected Components", test_num);
            adj_matrix = 16'h4812;
            start_node = 4'd3;
            @(posedge clk);
            #2 #1;
 check_outputs(4'b1100);
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
        input [3:0] expected_visited_nodes;
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
