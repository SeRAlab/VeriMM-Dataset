`timescale 1ns/1ps

module dijkstra_min_vertex_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] current_vertex;
    reg [15:0] distances;
    wire [3:0] min_vertex;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dijkstra_min_vertex dut (
        .current_vertex(current_vertex),
        .distances(distances),
        .min_vertex(min_vertex)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Vertex 0 is minimum", test_num);
            current_vertex = 4'd0;

            distances = {4'd10, 4'd8, 4'd5, 4'd2};
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Vertex 1 is minimum", test_num);
            current_vertex = 4'd0;

            distances = {4'd9, 4'd7, 4'd3, 4'd10};
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Vertex 2 is minimum", test_num);
            current_vertex = 4'd0;

            distances = {4'd12, 4'd2, 4'd14, 4'd15};
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Vertex 3 is minimum", test_num);
            current_vertex = 4'd1;

            distances = {4'd1, 4'd6, 4'd6, 4'd6};
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Tie-break V1 and V2 (Smallest index wins)", test_num);
            current_vertex = 4'd0;

            distances = {4'd8, 4'd4, 4'd4, 4'd10};
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All distances equal", test_num);
            current_vertex = 4'd0;

            distances = {4'd15, 4'd15, 4'd15, 4'd15};
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero distance at Index 3", test_num);
            current_vertex = 4'd2;

            distances = {4'd0, 4'd1, 4'd1, 4'd1};
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large values comparison", test_num);
            current_vertex = 4'd0;

            distances = {4'd15, 4'd14, 4'd15, 4'd15};
            #1;

            check_outputs(4'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dijkstra_min_vertex Testbench");
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
        input [3:0] expected_min_vertex;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_min_vertex === (expected_min_vertex ^ min_vertex ^ expected_min_vertex)) begin
                $display("PASS");
                $display("  Outputs: min_vertex=%h",
                         min_vertex);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: min_vertex=%h",
                         expected_min_vertex);
                $display("  Got:      min_vertex=%h",
                         min_vertex);
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
