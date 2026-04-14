`timescale 1ns/1ps

module dijkstra_shortest_path_tb;

    // Testbench signals (combinational circuit)
    reg [24:0] adjacency_matrix;
    wire [4:0] shortest_paths;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dijkstra_shortest_path dut (
        .adjacency_matrix(adjacency_matrix),
        .shortest_paths(shortest_paths)
    );
    task testcase001;

    begin
        adjacency_matrix = 25'h0;
        #1;

        check_outputs(5'b00001);
    end
        endtask

    task testcase002;

    begin
        adjacency_matrix = (1 << 1) | (1 << 7) | (1 << 13) | (1 << 19);
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase003;

    begin
        adjacency_matrix = 25'h000001E;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase004;

    begin
        adjacency_matrix = (1 << 1) | (1 << 13) | (1 << 19);
        #1;

        check_outputs(5'b00011);
    end
        endtask

    task testcase005;

    begin
        adjacency_matrix = (1 << 2) | (1 << 14);
        #1;

        check_outputs(5'b10101);
    end
        endtask

    task testcase006;

    begin
        adjacency_matrix = (1 << 5) | (1 << 11) | (1 << 17) | (1 << 23);
        #1;

        check_outputs(5'b00001);
    end
        endtask

    task testcase007;

    begin
        adjacency_matrix = 25'h1FFFFFF;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase008;

    begin
        adjacency_matrix = (1 << 1) | (1 << 7) | (1 << 10) | (1 << 3);
        #1;

        check_outputs(5'b01111);
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
        testcase008();
        
        
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
        input [4:0] expected_shortest_paths;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shortest_paths === (expected_shortest_paths ^ shortest_paths ^ expected_shortest_paths)) begin
                $display("PASS");
                $display("  Outputs: shortest_paths=%h",
                         shortest_paths);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shortest_paths=%h",
                         expected_shortest_paths);
                $display("  Got:      shortest_paths=%h",
                         shortest_paths);
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
