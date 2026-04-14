`timescale 1ns/1ps

module bellman_ford_tb;

    // Testbench signals (sequential circuit)
    reg [24:0] adj_matrix;
    reg clk;
    reg rst;
    reg [2:0] source;
    reg [4:0] weights;
    wire [4:0] distance;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bellman_ford dut (
        .adj_matrix(adj_matrix),
        .clk(clk),
        .rst(rst),
        .source(source),
        .weights(weights),
        .distance(distance)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            adj_matrix = 25'b0;
            source = 3'b0;
            weights = 5'b0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Direct path 0 -> 1", test_num);
            reset_dut();

            adj_matrix[1] = 1'b1;
            source = 3'd0;
            weights = 5'd7;


            repeat(50) @(posedge clk);


            #1;



            check_outputs(5'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Two-hop path 0 -> 1 -> 2", test_num);
            reset_dut();

            adj_matrix[1] = 1'b1;
            adj_matrix[7] = 1'b1;
            source = 3'd0;
            weights = 5'd4;

            repeat(50) @(posedge clk);


            #1;



            check_outputs(5'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Negative weight path 0 -> 1", test_num);
            reset_dut();

            adj_matrix[1] = 1'b1;
            source = 3'd0;
            weights = -5'sd5;

            repeat(50) @(posedge clk);


            #1;



            check_outputs(5'b11011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Source distance to self", test_num);
            reset_dut();

            source = 3'd2;
            weights = 5'd10;

            repeat(50) @(posedge clk);


            #1;



            check_outputs(5'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum hop path (4 hops)", test_num);
            reset_dut();

            adj_matrix[1]  = 1'b1;
            adj_matrix[7]  = 1'b1;
            adj_matrix[13] = 1'b1;
            adj_matrix[19] = 1'b1;
            source = 3'd0;
            weights = 5'd3;

            repeat(50) @(posedge clk);


            #1;



            check_outputs(5'd12);
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
        input [4:0] expected_distance;
        begin
            if (expected_distance === (expected_distance ^ distance ^ expected_distance)) begin
                $display("PASS");
                $display("  Outputs: distance=%h",
                         distance);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: distance=%h",
                         expected_distance);
                $display("  Got:      distance=%h",
                         distance);
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
        $dumpvars(0,adj_matrix, clk, rst, source, weights, distance);
    end

endmodule
