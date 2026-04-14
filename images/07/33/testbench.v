`timescale 1ns/1ps

module rrt_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] goal_x;
    reg [7:0] goal_y;
    reg [7:0] random_x;
    reg [7:0] random_y;
    reg reset;
    reg [7:0] start_x;
    reg [7:0] start_y;
    wire [7:0] closest_x;
    wire [7:0] closest_y;
    wire goal_reached;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt dut (
        .clk(clk),
        .goal_x(goal_x),
        .goal_y(goal_y),
        .random_x(random_x),
        .random_y(random_y),
        .reset(reset),
        .start_x(start_x),
        .start_y(start_y),
        .closest_x(closest_x),
        .closest_y(closest_y),
        .goal_reached(goal_reached)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start_x = 0;
            start_y = 0;
            goal_x = 0;
            goal_y = 0;
            random_x = 0;
            random_y = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Initialization Check");
            test_num = test_num + 1;

            reset = 1;
            start_x = 8'd10;
            start_y = 8'd10;
            goal_x = 8'd100;
            goal_y = 8'd100;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'd10, 8'd10, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Improvement Step");
            test_num = test_num + 1;


            reset = 1;
            start_x = 8'd10;
            start_y = 8'd10;
            goal_x = 8'd50;
            goal_y = 8'd50;
            @(posedge clk);
            #1 reset = 0;


            random_x = 8'd30;
            random_y = 8'd30;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'd30, 8'd30, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Rejection of Worse Points");
            test_num = test_num + 1;


            reset = 1;
            start_x = 8'd30;
            start_y = 8'd30;
            goal_x = 8'd50;
            goal_y = 8'd50;
            @(posedge clk);
            #1 reset = 0;


            random_x = 8'd10;
            random_y = 8'd10;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'd30, 8'd30, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Reaching the Goal");
            test_num = test_num + 1;


            reset = 1;
            start_x = 8'd10;
            start_y = 8'd10;
            goal_x = 8'd100;
            goal_y = 8'd100;
            @(posedge clk);
            #1 reset = 0;


            random_x = 8'd100;
            random_y = 8'd100;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'd100, 8'd100, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Multi-step Convergence");
            test_num = test_num + 1;


            reset = 1;
            start_x = 8'd0;
            start_y = 8'd0;
            goal_x = 8'd100;
            goal_y = 8'd100;
            @(posedge clk);
            #1 reset = 0;


            random_x = 8'd20; random_y = 8'd20;
            @(posedge clk); #1;


            random_x = 8'd10; random_y = 8'd10;
            @(posedge clk); #1;


            random_x = 8'd80; random_y = 8'd80;
            @(posedge clk); #1;


            random_x = 8'd70; random_y = 8'd70;
            @(posedge clk); #1;


            #1;



            check_outputs(8'd80, 8'd80, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt Testbench");
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
        input [7:0] expected_closest_x;
        input [7:0] expected_closest_y;
        input expected_goal_reached;
        begin
            if (expected_closest_x === (expected_closest_x ^ closest_x ^ expected_closest_x) &&
                expected_closest_y === (expected_closest_y ^ closest_y ^ expected_closest_y) &&
                expected_goal_reached === (expected_goal_reached ^ goal_reached ^ expected_goal_reached)) begin
                $display("PASS");
                $display("  Outputs: closest_x=%h, closest_y=%h, goal_reached=%b",
                         closest_x, closest_y, goal_reached);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: closest_x=%h, closest_y=%h, goal_reached=%b",
                         expected_closest_x, expected_closest_y, expected_goal_reached);
                $display("  Got:      closest_x=%h, closest_y=%h, goal_reached=%b",
                         closest_x, closest_y, goal_reached);
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
        $dumpvars(0,clk, goal_x, goal_y, random_x, random_y, reset, start_x, start_y, closest_x, closest_y, goal_reached);
    end

endmodule
