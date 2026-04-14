`timescale 1ns/1ps

module bellman_ford_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] edges;
    reg [2:0] source;
    reg [4:0] weights;
    wire [4:0] distances;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bellman_ford dut (
        .edges(edges),
        .source(source),
        .weights(weights),
        .distances(distances)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Source 0, No edges enabled");
        source = 3'd0;
        edges = 5'b00000;
        weights = 5'b00000;
        #1;

        check_outputs(5'b11110);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Source 0, Edge 0 (0->1) active, weight 0");
        source = 3'd0;
        edges = 5'b00001;
        weights = 5'b00000;
        #1;

        check_outputs(5'b11100);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Source 0, Edge 0 (0->1) active, weight 1");
        source = 3'd0;
        edges = 5'b00001;
        weights = 5'b00001;
        #1;

        check_outputs(5'b11110);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Source 0, Path 0->1->2 active, weights 0");
        source = 3'd0;
        edges = 5'b00011;
        weights = 5'b00000;
        #1;

        check_outputs(5'b11000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Source 0, Path 0->1->2 active, Edge 1 weight 1");
        source = 3'd0;
        edges = 5'b00011;
        weights = 5'b00010;
        #1;

        check_outputs(5'b11100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Source 0, Shortcut 0->2 weight 0 vs Path 0->1->2 weight 2");
        source = 3'd0;
        edges = 5'b10011;
        weights = 5'b00011;
        #1;

        check_outputs(5'b11010);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: Source 2, Path 2->3->4 active, weights 0");
        source = 3'd2;
        edges = 5'b01100;
        weights = 5'b00000;
        #1;

        check_outputs(5'b00011);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Source 3, Edge 3 (3->4) active, weight 1");
        source = 3'd3;
        edges = 5'b01000;
        weights = 5'b01000;
        #1;

        check_outputs(5'b10111);
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
