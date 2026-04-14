`timescale 1ns/1ps

module bellman_ford_tb;

    // Testbench signals (combinational circuit)
    reg [24:0] adj_matrix;
    reg [2:0] source;
    reg [4:0] weights;
    wire [4:0] distances;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bellman_ford dut (
        .adj_matrix(adj_matrix),
        .source(source),
        .weights(weights),
        .distances(distances)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Chain Path 0->1->2->3->4", test_num);
        source = 3'd0;
        weights = 5'd1;






        adj_matrix = 25'b10000_11000_01100_00110_00011;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Disconnected Components", test_num);
        source = 3'd0;
        weights = 5'd1;






        adj_matrix = 25'b10000_11000_01100_00011_00011;
        #1;

        check_outputs(5'b00011);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Source in Middle of Chain", test_num);
        source = 3'd2;
        weights = 5'd1;

        adj_matrix = 25'b10000_11000_01100_00110_00011;
        #1;

        check_outputs(5'b11100);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Source with No Outgoing Edges", test_num);
        source = 3'd1;
        weights = 5'd5;


        adj_matrix = 25'b00000_01000_00100_00010_00010;
        #1;

        check_outputs(5'b00010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Fully Connected Graph", test_num);
        source = 3'd4;
        weights = 5'd2;
        adj_matrix = 25'h1FFFFFF;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Convergence with Cycle", test_num);
        source = 3'd0;
        weights = 5'd1;




        adj_matrix = 25'b00000_01000_01101_00110_00011;
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
        $display("bellman_ford Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
