`timescale 1ns/1ps

module rrt_tree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] current_point_x;
    reg [7:0] current_point_y;
    reg rst;
    reg [7:0] target_point_x;
    reg [7:0] target_point_y;
    wire [7:0] next_point_x;
    wire [7:0] next_point_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_tree dut (
        .clk(clk),
        .current_point_x(current_point_x),
        .current_point_y(current_point_y),
        .rst(rst),
        .target_point_x(target_point_x),
        .target_point_y(target_point_y),
        .next_point_x(next_point_x),
        .next_point_y(next_point_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        current_point_x = 8'd0;
        current_point_y = 8'd0;
        target_point_x = 8'd0;
        target_point_y = 8'd0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Moving East (X+)", test_num);
        current_point_x = 8'd50;
        current_point_y = 8'd50;
        target_point_x = 8'd100;
        target_point_y = 8'd50;

        repeat(2) @(posedge clk);

        #1;


        check_outputs(8'd51, 8'd50);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Moving West (X-)", test_num);
        current_point_x = 8'd50;
        current_point_y = 8'd50;
        target_point_x = 8'd10;
        target_point_y = 8'd50;

        repeat(2) @(posedge clk);

        #1;


        check_outputs(8'd49, 8'd50);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Moving North (Y+)", test_num);
        current_point_x = 8'd50;
        current_point_y = 8'd50;
        target_point_x = 8'd50;
        target_point_y = 8'd100;

        repeat(2) @(posedge clk);

        #1;


        check_outputs(8'd50, 8'd51);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Moving South (Y-)", test_num);
        current_point_x = 8'd50;
        current_point_y = 8'd50;
        target_point_x = 8'd50;
        target_point_y = 8'd10;

        repeat(2) @(posedge clk);

        #1;


        check_outputs(8'd50, 8'd49);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Moving North-East (X+, Y+)", test_num);
        current_point_x = 8'd20;
        current_point_y = 8'd20;
        target_point_x = 8'd40;
        target_point_y = 8'd40;

        repeat(2) @(posedge clk);

        #1;


        check_outputs(8'd21, 8'd21);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %0d: Moving South-West (X-, Y-)", test_num);
        current_point_x = 8'd80;
        current_point_y = 8'd80;
        target_point_x = 8'd20;
        target_point_y = 8'd20;

        repeat(2) @(posedge clk);

        #1;


        check_outputs(8'd79, 8'd79);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        $display("Testcase %0d: Target Reached (No movement)", test_num);
        current_point_x = 8'd120;
        current_point_y = 8'd120;
        target_point_x = 8'd120;
        target_point_y = 8'd120;

        repeat(2) @(posedge clk);

        #1;


        check_outputs(8'd120, 8'd120);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        $display("Testcase %0d: Boundary condition near 0", test_num);
        current_point_x = 8'd1;
        current_point_y = 8'd1;
        target_point_x = 8'd0;
        target_point_y = 8'd0;

        repeat(2) @(posedge clk);

        #1;


        check_outputs(8'd0, 8'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_tree Testbench");
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
        input [7:0] expected_next_point_x;
        input [7:0] expected_next_point_y;
        begin
            if (expected_next_point_x === (expected_next_point_x ^ next_point_x ^ expected_next_point_x) &&
                expected_next_point_y === (expected_next_point_y ^ next_point_y ^ expected_next_point_y)) begin
                $display("PASS");
                $display("  Outputs: next_point_x=%h, next_point_y=%h",
                         next_point_x, next_point_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_point_x=%h, next_point_y=%h",
                         expected_next_point_x, expected_next_point_y);
                $display("  Got:      next_point_x=%h, next_point_y=%h",
                         next_point_x, next_point_y);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, current_point_x, current_point_y, rst, target_point_x, target_point_y, next_point_x, next_point_y);
    end

endmodule
