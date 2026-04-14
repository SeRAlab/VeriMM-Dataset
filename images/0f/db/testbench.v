`timescale 1ns/1ps

module BFS_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] adjacency_matrix;
    reg clk;
    reg reset;
    reg [1:0] start_node;
    wire [7:0] visited_order;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    BFS dut (
        .adjacency_matrix(adjacency_matrix),
        .clk(clk),
        .reset(reset),
        .start_node(start_node),
        .visited_order(visited_order)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            adjacency_matrix = 16'h0;
            start_node = 2'b00;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Simple Line Graph 0->1->2->3", test_num);
            adjacency_matrix = 16'h0842;
            start_node = 2'd0;
            #100;

            #1;


            check_outputs(8'h1B);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Star Graph (0 connects to all)", test_num);
            adjacency_matrix = 16'h000E;
            start_node = 2'd0;
            #100;

            #1;


            check_outputs(8'h1B);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Ring Graph starting at Node 2", test_num);
            adjacency_matrix = 16'h1842;
            start_node = 2'd2;
            #100;

            #1;


            check_outputs(8'hB1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Disconnected Components (Start at 0)", test_num);
            adjacency_matrix = 16'h0802;
            start_node = 2'd0;
            #100;

            #1;


            check_outputs(8'h10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case %0d: Complex Branching 0->(1,2)->3", test_num);
            adjacency_matrix = 16'h0886;
            start_node = 2'd0;
            #100;

            #1;


            check_outputs(8'h1B);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("BFS Testbench");
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
        input [7:0] expected_visited_order;
        begin
            if (expected_visited_order === (expected_visited_order ^ visited_order ^ expected_visited_order)) begin
                $display("PASS");
                $display("  Outputs: visited_order=%h",
                         visited_order);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: visited_order=%h",
                         expected_visited_order);
                $display("  Got:      visited_order=%h",
                         visited_order);
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
        $dumpvars(0,adjacency_matrix, clk, reset, start_node, visited_order);
    end

endmodule
