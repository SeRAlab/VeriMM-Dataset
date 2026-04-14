`timescale 1ns/1ps

module a_star_search_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] goal;
    reg [24:0] grid;
    reg [4:0] start;
    wire [24:0] path;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    a_star_search dut (
        .goal(goal),
        .grid(grid),
        .start(start),
        .path(path)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Straight Horizontal Path (0,0) to (0,4)", test_num);
            grid = 25'h1FFFFFF;
            start = 5'd0;
            goal = 5'd4;

            #1;


            check_outputs(25'h000001F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Straight Vertical Path (0,0) to (4,0)", test_num);
            grid = 25'h1FFFFFF;
            start = 5'd0;
            goal = 5'd20;


            #1;



            check_outputs(25'h0108421);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Start Position Equals Goal Position", test_num);
            grid = 25'h1FFFFFF;
            start = 5'd12;
            goal = 5'd12;

            #1;


            check_outputs(25'h0001000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: L-Shaped Path (0,0) to (2,2)", test_num);
            grid = 25'h1FFFFFF;
            start = 5'd0;
            goal = 5'd12;



            #1;




            check_outputs(25'h0001087);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Forced Snake Path (Obstacle Bypass)", test_num);






            grid = 25'h1F0FE1F;
            start = 5'd0;
            goal = 5'd24;

            #1;


            check_outputs(25'h1F0FE1F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small Obstacle Avoidance (0,0) to (1,1)", test_num);

            grid = 25'h1FFFFFD;
            start = 5'd0;
            goal = 5'd6;



            #1;




            check_outputs(25'h0000061);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Impossible Path (Goal Isolated)", test_num);

            grid = 25'h1FFFE1F;
            start = 5'd0;
            goal = 5'd24;


            #1;



            check_outputs(25'h0000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("a_star_search Testbench");
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
        input [24:0] expected_path;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_path === (expected_path ^ path ^ expected_path)) begin
                $display("PASS");
                $display("  Outputs: path=%h",
                         path);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: path=%h",
                         expected_path);
                $display("  Got:      path=%h",
                         path);
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
