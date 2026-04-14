`timescale 1ns/1ps

module dijkstra_shortest_path_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] destination;
    reg [15:0] edges;
    reg [3:0] source;
    wire [7:0] min_distance;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dijkstra_shortest_path dut (
        .destination(destination),
        .edges(edges),
        .source(source),
        .min_distance(min_distance)
    );
    task testcase001;

    begin
        test_num = 1;
        source = 4'd0;
        destination = 4'd0;
        edges = 16'hFFFF;
        #10;
        $display("Test %0d: Source equals Destination", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        source = 4'd0;
        destination = 4'd1;

        edges = 16'hFFF5;
        #10;
        $display("Test %0d: Direct path Node 0 to Node 1", test_num);
        #1;

        check_outputs(8'h05);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        source = 4'd0;
        destination = 4'd2;

        edges = 16'hFF43;
        #10;
        $display("Test %0d: Indirect path Node 0 -> 1 -> 2", test_num);
        #1;

        check_outputs(8'h07);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        source = 4'd0;
        destination = 4'd2;

        edges = 16'hC32;
        #10;
        $display("Test %0d: Shortest path selection (Indirect is shorter)", test_num);
        #1;

        check_outputs(8'h05);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        source = 4'd0;
        destination = 4'd2;

        edges = 16'h466;
        #10;
        $display("Test %0d: Shortest path selection (Direct is shorter)", test_num);
        #1;

        check_outputs(8'h04);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        source = 4'd0;
        destination = 4'd3;
        edges = 16'hF222;
        #10;
        $display("Test %0d: Multi-hop chain path 0 -> 1 -> 2 -> 3", test_num);
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        source = 4'd3;
        destination = 4'd0;
        edges = 16'h1111;
        #10;
        $display("Test %0d: Unreachable node", test_num);

        #1;


        check_outputs(8'hFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dijkstra_shortest_path Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_min_distance;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_min_distance === (expected_min_distance ^ min_distance ^ expected_min_distance)) begin
                $display("PASS");
                $display("  Outputs: min_distance=%h",
                         min_distance);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: min_distance=%h",
                         expected_min_distance);
                $display("  Got:      min_distance=%h",
                         min_distance);
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

endmodule
