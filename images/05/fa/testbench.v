`timescale 1ns/1ps

module bfs_tb;

    // Testbench signals (sequential circuit)
    reg [24:0] adj_matrix;
    reg clk;
    reg reset;
    reg [4:0] start_node;
    wire [4:0] visited_nodes;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bfs dut (
        .adj_matrix(adj_matrix),
        .clk(clk),
        .reset(reset),
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
            reset = 1;
            adj_matrix = 0;
            start_node = 0;
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Linear Chain");
            reset_dut();

            adj_matrix = (1 << 1) | (1 << 7) | (1 << 13) | (1 << 19);
            start_node = 5'b00001;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Disconnected Graph");
            reset_dut();

            adj_matrix = (1 << 1) | (1 << 19);
            start_node = 5'b00001;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(5'b00011);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Cyclic Graph");
            reset_dut();

            adj_matrix = (1 << 1) | (1 << 7) | (1 << 10);
            start_node = 5'b00010;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(5'b00111);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Star Graph");
            reset_dut();

            adj_matrix = (1 << 1) | (1 << 2) | (1 << 3) | (1 << 4);
            start_node = 5'b00001;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: No Edges");
            reset_dut();
            adj_matrix = 25'b0;
            start_node = 5'b00100;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(5'b00100);
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
        input [4:0] expected_visited_nodes;
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
        $dumpvars(0,adj_matrix, clk, reset, start_node, visited_nodes);
    end

endmodule
