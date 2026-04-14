`timescale 1ns/1ps

module astar_heuristic_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] x1;
    reg [4:0] x2;
    reg [4:0] y1;
    reg [4:0] y2;
    wire [5:0] heuristic_cost;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    astar_heuristic dut (
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2),
        .heuristic_cost(heuristic_cost)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identical nodes (10,10) to (10,10)", test_num);
            x1 = 5'd10; y1 = 5'd10;
            x2 = 5'd10; y2 = 5'd10;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pure horizontal (5,0) to (25,0)", test_num);
            x1 = 5'd5;  y1 = 5'd0;
            x2 = 5'd25; y2 = 5'd0;
            #1;

            check_outputs(6'd20);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pure horizontal (25,0) to (5,0)", test_num);
            x1 = 5'd25; y1 = 5'd0;
            x2 = 5'd5;  y2 = 5'd0;
            #1;

            check_outputs(6'd20);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pure vertical (0,5) to (0,30)", test_num);
            x1 = 5'd0; y1 = 5'd5;
            x2 = 5'd0; y2 = 5'd30;
            #1;

            check_outputs(6'd25);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: General diagonal (2,3) to (10,15)", test_num);
            x1 = 5'd2;  y1 = 5'd3;
            x2 = 5'd10; y2 = 5'd15;
            #1;

            check_outputs(6'd20);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max distance (0,0) to (31,31)", test_num);
            x1 = 5'd0;  y1 = 5'd0;
            x2 = 5'd31; y2 = 5'd31;
            #1;

            check_outputs(6'd62);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed diff (20,5) to (10,15)", test_num);
            x1 = 5'd20; y1 = 5'd5;
            x2 = 5'd10; y2 = 5'd15;
            #1;

            check_outputs(6'd20);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Corner diagonal (31,0) to (0,31)", test_num);
            x1 = 5'd31; y1 = 5'd0;
            x2 = 5'd0;  y2 = 5'd31;
            #1;

            check_outputs(6'd62);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("astar_heuristic Testbench");
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
        input [5:0] expected_heuristic_cost;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_heuristic_cost === (expected_heuristic_cost ^ heuristic_cost ^ expected_heuristic_cost)) begin
                $display("PASS");
                $display("  Outputs: heuristic_cost=%h",
                         heuristic_cost);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: heuristic_cost=%h",
                         expected_heuristic_cost);
                $display("  Got:      heuristic_cost=%h",
                         heuristic_cost);
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
