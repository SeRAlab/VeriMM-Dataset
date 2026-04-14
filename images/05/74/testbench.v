`timescale 1ns/1ps

module bfs_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] adjacency_matrix;
    reg clk;
    reg reset;
    reg start;
    reg [1:0] start_node;
    wire done;
    wire [3:0] visited_nodes;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bfs dut (
        .adjacency_matrix(adjacency_matrix),
        .clk(clk),
        .reset(reset),
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
            reset = 1;
            start = 0;
            adjacency_matrix = 16'h0;
            start_node = 2'b0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            adjacency_matrix = 16'hFFFF;
            start_node = 2'd0;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'b1111);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;


            adjacency_matrix = 16'hCC33;
            start_node = 2'd0;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'b0011);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            adjacency_matrix = 16'hCC33;
            start_node = 2'd3;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'b1100);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            adjacency_matrix = 16'hCE73;
            start_node = 2'd0;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 4'b1111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            adjacency_matrix = 16'h0000;
            start_node = 2'd2;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
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
        $dumpvars(0,adjacency_matrix, clk, reset, start, start_node, done, visited_nodes);
    end

endmodule
