`timescale 1ns/1ps

module dijkstra_shortest_path_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] weight_0_1;
    reg [3:0] weight_0_2;
    reg [3:0] weight_1_2;
    wire [3:0] shortest_distance;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dijkstra_shortest_path dut (
        .weight_0_1(weight_0_1),
        .weight_0_2(weight_0_2),
        .weight_1_2(weight_1_2),
        .shortest_distance(shortest_distance)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Direct path is shorter (4 < 5+5)", test_num);
            weight_0_1 = 4'd5;
            weight_1_2 = 4'd5;
            weight_0_2 = 4'd4;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Indirect path is shorter (2+3 < 10)", test_num);
            weight_0_1 = 4'd2;
            weight_1_2 = 4'd3;
            weight_0_2 = 4'd10;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Both paths are equal (4+4 == 8)", test_num);
            weight_0_1 = 4'd4;
            weight_1_2 = 4'd4;
            weight_0_2 = 4'd8;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Indirect path weight is zero", test_num);
            weight_0_1 = 4'd0;
            weight_1_2 = 4'd0;
            weight_0_2 = 4'd7;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Direct path weight is zero", test_num);
            weight_0_1 = 4'd1;
            weight_1_2 = 4'd1;
            weight_0_2 = 4'd0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Max boundary path (7+8 == 15)", test_num);
            weight_0_1 = 4'd7;
            weight_1_2 = 4'd8;
            weight_0_2 = 4'd15;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Subtle difference (6+6 < 13)", test_num);
            weight_0_1 = 4'd6;
            weight_1_2 = 4'd6;
            weight_0_2 = 4'd13;
            #1;

            check_outputs(4'd12);
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
        input [3:0] expected_shortest_distance;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_shortest_distance === (expected_shortest_distance ^ shortest_distance ^ expected_shortest_distance)) begin
                $display("PASS");
                $display("  Outputs: shortest_distance=%h",
                         shortest_distance);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shortest_distance=%h",
                         expected_shortest_distance);
                $display("  Got:      shortest_distance=%h",
                         shortest_distance);
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
