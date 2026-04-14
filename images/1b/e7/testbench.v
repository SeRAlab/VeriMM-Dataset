`timescale 1ns/1ps

module bellman_ford_tb;

    // Testbench signals (combinational circuit)
    reg [24:0] adj_matrix;
    reg [4:0] src;
    wire [4:0] dist;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bellman_ford dut (
        .adj_matrix(adj_matrix),
        .src(src),
        .dist(dist)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Direct path 0 -> 4", test_num);
        adj_matrix = (1 << 4);
        src = 5'd0;
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Two-hop path 0 -> 1 -> 4", test_num);
        adj_matrix = (1 << 1) | (1 << 9);
        src = 5'd0;
        #1;

        check_outputs(5'd2);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum hop path 0 -> 1 -> 2 -> 3 -> 4", test_num);

        adj_matrix = (1 << 1) | (1 << 7) | (1 << 13) | (1 << 19);
        src = 5'd0;
        #1;

        check_outputs(5'd4);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiple paths (Shortest Selection)", test_num);

        adj_matrix = (1 << 4) | (1 << 1) | (1 << 7) | (1 << 13) | (1 << 19);
        src = 5'd0;
        #1;

        check_outputs(5'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: No path available (Infinity check)", test_num);
        adj_matrix = 25'h0000000;
        src = 5'd0;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Source is destination (Dist = 0)", test_num);
        adj_matrix = (1 << 20);
        src = 5'd4;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Graph with cycles", test_num);


        adj_matrix = (1 << 1) | (1 << 5) | (1 << 7) | (1 << 14) | (1 << 3) | (1 << 19);
        src = 5'd0;
        #1;

        check_outputs(5'd2);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Intermediate source vertex 2", test_num);

        adj_matrix = (1 << 13) | (1 << 19);
        src = 5'd2;
        #1;

        check_outputs(5'd2);
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
        input [4:0] expected_dist;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dist === (expected_dist ^ dist ^ expected_dist)) begin
                $display("PASS");
                $display("  Outputs: dist=%h",
                         dist);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dist=%h",
                         expected_dist);
                $display("  Got:      dist=%h",
                         dist);
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
