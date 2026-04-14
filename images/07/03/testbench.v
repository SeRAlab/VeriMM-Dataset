`timescale 1ns/1ps

module bellman_ford_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [19:0] edges;
    reg [4:0] edges_valid;
    reg rst;
    reg [4:0] src_vertex;
    wire done;
    wire [79:0] shortest_paths;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bellman_ford dut (
        .clk(clk),
        .edges(edges),
        .edges_valid(edges_valid),
        .rst(rst),
        .src_vertex(src_vertex),
        .done(done),
        .shortest_paths(shortest_paths)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            edges = 0;
            edges_valid = 0;
            src_vertex = 0;
            repeat(5) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task load_edge;

        input [3:0] u;
        input [3:0] v;
        input signed [11:0] w;
        begin
            edges = {u, v, w};
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Simple Chain Path", test_num);
            reset_dut();
            src_vertex = 0;
            edges_valid = 5'd2;
            load_edge(4'd0, 4'd1, 12'sd5);
            load_edge(4'd1, 4'd2, 12'sd10);
            edges = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 80'h7F7F7F7F7F7F7F0F0500);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Shortcut Detection", test_num);
            reset_dut();
            src_vertex = 0;
            edges_valid = 5'd3;
            load_edge(4'd0, 4'd1, 12'sd10);
            load_edge(4'd0, 4'd2, 12'sd2);
            load_edge(4'd2, 4'd1, 12'sd3);
            edges = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 80'h7F7F7F7F7F7F7F020500);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Negative Weight", test_num);
            reset_dut();
            src_vertex = 0;
            edges_valid = 5'd2;
            load_edge(4'd0, 4'd1, 12'sd10);
            load_edge(4'd1, 4'd2, 12'sd-5);
            edges = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 80'h7F7F7F7F7F7F7F050A00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Alternative Source Vertex", test_num);
            reset_dut();
            src_vertex = 5'd2;
            edges_valid = 5'd2;
            load_edge(4'd2, 4'd0, 12'sd5);
            load_edge(4'd2, 4'd3, 12'sd1);
            edges = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 80'h7F7F7F7F7F7F01007F05);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Multi-node Complex Graph", test_num);
            reset_dut();
            src_vertex = 0;
            edges_valid = 5'd4;
            load_edge(4'd0, 4'd1, 12'sd1);
            load_edge(4'd1, 4'd2, 12'sd1);
            load_edge(4'd2, 4'd3, 12'sd1);
            load_edge(4'd0, 4'd3, 12'sd5);
            edges = 0;
            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 80'h7F7F7F7F7F7F03020100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bellman_ford Testbench");
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
        input [79:0] expected_shortest_paths;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_shortest_paths === (expected_shortest_paths ^ shortest_paths ^ expected_shortest_paths)) begin
                $display("PASS");
                $display("  Outputs: done=%b, shortest_paths=%h",
                         done, shortest_paths);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, shortest_paths=%h",
                         expected_done, expected_shortest_paths);
                $display("  Got:      done=%b, shortest_paths=%h",
                         done, shortest_paths);
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
        $dumpvars(0,clk, edges, edges_valid, rst, src_vertex, done, shortest_paths);
    end

endmodule
