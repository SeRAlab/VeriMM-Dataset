`timescale 1ns/1ps

module AStarSearch_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] end_x;
    reg [4:0] end_y;
    reg [24:0] grid;
    reg [4:0] start_x;
    reg [4:0] start_y;
    wire [24:0] path;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    AStarSearch dut (
        .end_x(end_x),
        .end_y(end_y),
        .grid(grid),
        .start_x(start_x),
        .start_y(start_y),
        .path(path)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Horizontal Path (0,0) to (4,0)", test_num);


            start_x = 5'd0;
            start_y = 5'd0;
            end_x   = 5'd4;
            end_y   = 5'd0;
            grid    = 25'h0;




            #1;





            check_outputs(25'h1F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Vertical Path (0,0) to (0,4)", test_num);


            start_x = 5'd0;
            start_y = 5'd0;
            end_x   = 5'd0;
            end_y   = 5'd4;
            grid    = 25'h0;




            #1;





            check_outputs(25'h1041041);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Bypass Obstacle at (1,0)", test_num);


            start_x = 5'd0;
            start_y = 5'd0;
            end_x   = 5'd2;
            end_y   = 5'd0;
            grid    = 25'h2;





            #1;






            check_outputs(25'hE5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Start Equals End (2,2)", test_num);

            start_x = 5'd2;
            start_y = 5'd2;
            end_x   = 5'd2;
            end_y   = 5'd2;
            grid    = 25'h0;



            #1;




            check_outputs(25'h1000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Diagonal step (0,0) to (1,1)", test_num);

            start_x = 5'd0;
            start_y = 5'd0;
            end_x   = 5'd1;
            end_y   = 5'd1;
            grid    = 25'h0;




            #1;





            check_outputs(25'h43);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Unreachable Target (Wall)", test_num);

            start_x = 5'd0;
            start_y = 5'd0;
            end_x   = 5'd4;
            end_y   = 5'd4;

            grid    = 25'h421084;


            #1;



            check_outputs(25'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("AStarSearch Testbench");
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
