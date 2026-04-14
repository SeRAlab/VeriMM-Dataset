`timescale 1ns/1ps

module graph_coloring_tb;

    // Testbench signals (combinational circuit)
    reg [24:0] adj_matrix;
    wire [4:0] colors;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    graph_coloring dut (
        .adj_matrix(adj_matrix),
        .colors(colors)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Empty Graph", test_num);
            adj_matrix = 25'h0;

            #1;


            check_outputs(10'b00_00_00_00_00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Path Graph 0-1-2-3-4", test_num);

            adj_matrix = 25'h8A28A2;

            #1;


            check_outputs(10'b00_01_00_01_00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Star Graph (Center 0)", test_num);

            adj_matrix = 25'h10843E;

            #1;


            check_outputs(10'b01_01_01_01_00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Clique K3 (0,1,2)", test_num);

            adj_matrix = 25'hCA6;

            #1;


            check_outputs(10'b00_00_10_01_00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Cycle Graph C5", test_num);

            adj_matrix = 25'h9A5532;

            #1;


            check_outputs(10'b10_01_00_01_00);
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
        input [4:0] expected_colors;
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
