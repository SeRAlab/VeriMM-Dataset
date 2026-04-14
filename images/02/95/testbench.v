`timescale 1ns/1ps

module bellman_ford_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [24:0] graph_weights;
    reg reset;
    reg [2:0] source;
    reg start;
    wire finished;
    wire [4:0] shortest_distances;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bellman_ford dut (
        .clk(clk),
        .graph_weights(graph_weights),
        .reset(reset),
        .source(source),
        .start(start),
        .finished(finished),
        .shortest_distances(shortest_distances)
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
            source = 0;
            graph_weights = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Linear Chain (0->1->2->3->4)", test_num);
            reset_dut();
            source = 3'd0;

            graph_weights = (1 << 1) | (1 << 7) | (1 << 13) | (1 << 19);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(finished);
            #10;
            #1;

            check_outputs(1'b1, 5'd4);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Direct Shortcut (0->4)", test_num);
            reset_dut();
            source = 3'd0;

            graph_weights = (1 << 4);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(finished);
            #10;
            #1;

            check_outputs(1'b1, 5'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Multiple Paths (Min selection)", test_num);
            reset_dut();
            source = 3'd0;

            graph_weights = (1 << 1) | (1 << 9) | (1 << 2) | (1 << 13) | (1 << 19);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(finished);
            #10;
            #1;

            check_outputs(1'b1, 5'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Unreachable Node", test_num);
            reset_dut();
            source = 3'd0;

            graph_weights = (1 << 1) | (1 << 7);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(finished);
            #10;
            #1;

            check_outputs(1'b1, 5'd31);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Source is Target (Node 4)", test_num);
            reset_dut();
            source = 3'd4;

            graph_weights = (1 << 1) | (1 << 7) | (1 << 13) | (1 << 19);
            start = 1;
            @(posedge clk);
            start = 0;

            wait(finished);
            #10;
            #1;

            check_outputs(1'b1, 5'd0);
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
        input expected_finished;
        input [4:0] expected_shortest_distances;
        begin
            if (expected_finished === (expected_finished ^ finished ^ expected_finished) &&
                expected_shortest_distances === (expected_shortest_distances ^ shortest_distances ^ expected_shortest_distances)) begin
                $display("PASS");
                $display("  Outputs: finished=%b, shortest_distances=%h",
                         finished, shortest_distances);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: finished=%b, shortest_distances=%h",
                         expected_finished, expected_shortest_distances);
                $display("  Got:      finished=%b, shortest_distances=%h",
                         finished, shortest_distances);
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
        $dumpvars(0,clk, graph_weights, reset, source, start, finished, shortest_distances);
    end

endmodule
