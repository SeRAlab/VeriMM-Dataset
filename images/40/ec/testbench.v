`timescale 1ns/1ps

module RRT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] goal_x;
    reg [4:0] goal_y;
    reg rst;
    reg [4:0] start_x;
    reg [4:0] start_y;
    wire done;
    wire [4:0] path_x;
    wire [4:0] path_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RRT dut (
        .clk(clk),
        .goal_x(goal_x),
        .goal_y(goal_y),
        .rst(rst),
        .start_x(start_x),
        .start_y(start_y),
        .done(done),
        .path_x(path_x),
        .path_y(path_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        start_x = 0;
        start_y = 0;
        goal_x = 0;
        goal_y = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task wait_for_done;

        input integer max_cycles;
        integer i;
        begin
            i = 0;
            while (!done && i < max_cycles) begin
                @(posedge clk);
                i = i + 1;
            end
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Simple Path (0,0) to (10,10)", test_num);
        reset_dut();
        start_x = 5'd0;
        start_y = 5'd0;
        goal_x = 5'd10;
        goal_y = 5'd10;


        wait_for_done(500);


        #1;



        check_outputs(1'b1, 5'd10, 5'd10);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Start equals Goal (5,5) to (5,5)", test_num);
        reset_dut();
        start_x = 5'd5;
        start_y = 5'd5;
        goal_x = 5'd5;
        goal_y = 5'd5;


        wait_for_done(10);

        #1;


        check_outputs(1'b1, 5'd5, 5'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Maximum Distance (0,0) to (31,31)", test_num);
        reset_dut();
        start_x = 5'd0;
        start_y = 5'd0;
        goal_x = 5'd31;
        goal_y = 5'd31;


        wait_for_done(2000);

        #1;


        check_outputs(1'b1, 5'd31, 5'd31);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Axis-aligned movement (15,0) to (15,30)", test_num);
        reset_dut();
        start_x = 5'd15;
        start_y = 5'd0;
        goal_x = 5'd15;
        goal_y = 5'd30;

        wait_for_done(1000);

        #1;


        check_outputs(1'b1, 5'd15, 5'd30);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Reverse direction (20,20) to (2,2)", test_num);
        reset_dut();
        start_x = 5'd20;
        start_y = 5'd20;
        goal_x = 5'd2;
        goal_y = 5'd2;

        wait_for_done(1000);

        #1;


        check_outputs(1'b1, 5'd2, 5'd2);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("RRT Testbench");
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
        input expected_done;
        input [4:0] expected_path_x;
        input [4:0] expected_path_y;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_path_x === (expected_path_x ^ path_x ^ expected_path_x) &&
                expected_path_y === (expected_path_y ^ path_y ^ expected_path_y)) begin
                $display("PASS");
                $display("  Outputs: done=%b, path_x=%h, path_y=%h",
                         done, path_x, path_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, path_x=%h, path_y=%h",
                         expected_done, expected_path_x, expected_path_y);
                $display("  Got:      done=%b, path_x=%h, path_y=%h",
                         done, path_x, path_y);
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
        $dumpvars(0,clk, goal_x, goal_y, rst, start_x, start_y, done, path_x, path_y);
    end

endmodule
