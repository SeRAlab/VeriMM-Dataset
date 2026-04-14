`timescale 1ns/1ps

module dijkstra_tb;

    // Testbench signals (combinational circuit)
    reg [24:0] adjacency_matrix;
    reg [2:0] start_vertex;
    wire [4:0] distances;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dijkstra dut (
        .adjacency_matrix(adjacency_matrix),
        .start_vertex(start_vertex),
        .distances(distances)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identity Matrix (Only self-loops), Start at 0", test_num);


        adjacency_matrix = 25'b10000_01000_00100_00010_00001;
        start_vertex = 3'd0;
        #1;

        check_outputs(5'b00001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Line Graph 0->1->2->3->4, Start at 0", test_num);


        adjacency_matrix = 25'b10000_11000_01100_00110_00011;
        start_vertex = 3'd0;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Disconnected Components (0-1-2) and (3-4), Start at 0", test_num);


        adjacency_matrix = 25'b10000_11000_00100_00110_00011;
        start_vertex = 3'd0;
        #1;

        check_outputs(5'b00111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Star Graph (Node 2 connects to all), Start at 2", test_num);


        adjacency_matrix = 25'b10000_01000_11111_00010_00001;
        start_vertex = 3'd2;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reverse Path 4->3->2, Start at 4", test_num);


        adjacency_matrix = 25'b11000_01100_00100_00010_00001;
        start_vertex = 3'd4;
        #1;

        check_outputs(5'b11100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Fully Connected Graph, Start at 3", test_num);

        adjacency_matrix = 25'h1FFFFFF;
        start_vertex = 3'd3;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sink Node (All point to 0, 0 points to none), Start at 1", test_num);


        adjacency_matrix = 25'b10001_01001_00101_00011_00001;
        start_vertex = 3'd1;
        #1;

        check_outputs(5'b00011);
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
        input [4:0] expected_distances;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_distances === (expected_distances ^ distances ^ expected_distances)) begin
                $display("PASS");
                $display("  Outputs: distances=%h",
                         distances);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: distances=%h",
                         expected_distances);
                $display("  Got:      distances=%h",
                         distances);
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
