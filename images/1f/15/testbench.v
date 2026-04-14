`timescale 1ns/1ps

module rrt_node_selector_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] y1;
    reg [7:0] y2;
    wire [7:0] nearest_x;
    wire [7:0] nearest_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_node_selector dut (
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2),
        .nearest_x(nearest_x),
        .nearest_y(nearest_y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Node 1 (10,10) vs Node 2 (100,100)", test_num);
        x1 = 8'd10;
        y1 = 8'd10;
        x2 = 8'd100;
        y2 = 8'd100;

        #1;


        check_outputs(8'd10, 8'd10);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Node 1 (200,200) vs Node 2 (5,5)", test_num);
        x1 = 8'd200;
        y1 = 8'd200;
        x2 = 8'd5;
        y2 = 8'd5;

        #1;


        check_outputs(8'd5, 8'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Node 1 (0,20) vs Node 2 (15,0)", test_num);
        x1 = 8'd0;
        y1 = 8'd20;
        x2 = 8'd15;
        y2 = 8'd0;

        #1;


        check_outputs(8'd15, 8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Node 1 (0,0) vs Node 2 (1,1)", test_num);
        x1 = 8'd0;
        y1 = 8'd0;
        x2 = 8'd1;
        y2 = 8'd1;

        #1;


        check_outputs(8'd0, 8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Tie Case - Node 1 (3,4) vs Node 2 (4,3)", test_num);
        x1 = 8'd3;
        y1 = 8'd4;
        x2 = 8'd4;
        y2 = 8'd3;

        #1;


        check_outputs(8'd3, 8'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large values - Node 1 (250,250) vs Node 2 (255,255)", test_num);
        x1 = 8'd250;
        y1 = 8'd250;
        x2 = 8'd255;
        y2 = 8'd255;

        #1;


        check_outputs(8'd250, 8'd250);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Small distance diff - Node 1 (10,0) vs Node 2 (7,7)", test_num);
        x1 = 8'd10;
        y1 = 8'd0;
        x2 = 8'd7;
        y2 = 8'd7;

        #1;


        check_outputs(8'd7, 8'd7);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_node_selector Testbench");
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
        input [7:0] expected_nearest_x;
        input [7:0] expected_nearest_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_nearest_x === (expected_nearest_x ^ nearest_x ^ expected_nearest_x) &&
                expected_nearest_y === (expected_nearest_y ^ nearest_y ^ expected_nearest_y)) begin
                $display("PASS");
                $display("  Outputs: nearest_x=%h, nearest_y=%h",
                         nearest_x, nearest_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nearest_x=%h, nearest_y=%h",
                         expected_nearest_x, expected_nearest_y);
                $display("  Got:      nearest_x=%h, nearest_y=%h",
                         nearest_x, nearest_y);
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
