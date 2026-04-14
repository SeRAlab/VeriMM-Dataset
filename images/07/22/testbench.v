`timescale 1ns/1ps

module dijkstra_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] adj_matrix;
    reg clk;
    reg rst;
    reg [3:0] source;
    wire [15:0] paths;
    wire [3:0] shortest_distances;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dijkstra dut (
        .adj_matrix(adj_matrix),
        .clk(clk),
        .rst(rst),
        .source(source),
        .paths(paths),
        .shortest_distances(shortest_distances)
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
            source = 4'd0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Star Graph (Source 0 to 1, 2, 3)", test_num);
            reset_dut();


            adj_matrix = 16'h000E;
            source = 4'd0;
            #100;

            #1;


            check_outputs(16'h0000, 4'b1111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Linear Chain (0->1->2->3)", test_num);
            reset_dut();

            adj_matrix = 16'h0842;
            source = 4'd0;
            #100;


            #1;



            check_outputs(16'h2100, 4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Disconnected Graph (0->1 and 2->3)", test_num);
            reset_dut();

            adj_matrix = 16'h0802;
            source = 4'd0;
            #100;


            #1;



            check_outputs(16'hFF00, 4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Source Node 2 in a Loop", test_num);
            reset_dut();

            adj_matrix = 16'h1842;
            source = 4'd2;
            #100;



            #1;




            check_outputs(16'h2203, 4'b1111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dijkstra Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [15:0] expected_paths;
        input [3:0] expected_shortest_distances;
        begin
            if (expected_paths === (expected_paths ^ paths ^ expected_paths) &&
                expected_shortest_distances === (expected_shortest_distances ^ shortest_distances ^ expected_shortest_distances)) begin
                $display("PASS");
                $display("  Outputs: paths=%h, shortest_distances=%h",
                         paths, shortest_distances);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: paths=%h, shortest_distances=%h",
                         expected_paths, expected_shortest_distances);
                $display("  Got:      paths=%h, shortest_distances=%h",
                         paths, shortest_distances);
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
        $dumpvars(0,adj_matrix, clk, rst, source, paths, shortest_distances);
    end

endmodule
