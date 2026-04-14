`timescale 1ns/1ps

module graph_coloring_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] edges;
    wire [3:0] colors;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    graph_coloring dut (
        .edges(edges),
        .colors(colors)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Empty Graph (No edges)", test_num);
            edges = 4'b0000;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Edge (v0-v1)", test_num);
            edges = 4'b0001;


            #1;



            check_outputs(4'b1010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Edge (v1-v2)", test_num);
            edges = 4'b0010;

            #1;


            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two Edges (v0-v1, v1-v2)", test_num);
            edges = 4'b0011;

            #1;


            check_outputs(4'b1010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Path Graph (v0-v1, v1-v2, v2-v3)", test_num);
            edges = 4'b0111;

            #1;


            check_outputs(4'b1010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Cycle Graph C4 (v0-v1, v1-v2, v2-v3, v3-v0)", test_num);
            edges = 4'b1111;

            #1;


            check_outputs(4'b1010);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Disconnected Edges (v0-v1 and v2-v3)", test_num);
            edges = 4'b0101;

            #1;


            check_outputs(4'b1010);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Vertices Connected to v0 (Star graph center v0)", test_num);


            edges = 4'b1001;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("graph_coloring Testbench");
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
        input [3:0] expected_colors;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_colors === (expected_colors ^ colors ^ expected_colors)) begin
                $display("PASS");
                $display("  Outputs: colors=%h",
                         colors);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: colors=%h",
                         expected_colors);
                $display("  Got:      colors=%h",
                         colors);
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
