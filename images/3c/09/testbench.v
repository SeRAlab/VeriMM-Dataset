`timescale 1ns/1ps

module RRT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] goal_x;
    reg [7:0] goal_y;
    reg reset;
    reg [7:0] start_x;
    reg [7:0] start_y;
    wire goal_reached;
    wire [7:0] path_x;
    wire [7:0] path_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RRT dut (
        .clk(clk),
        .goal_x(goal_x),
        .goal_y(goal_y),
        .reset(reset),
        .start_x(start_x),
        .start_y(start_y),
        .goal_reached(goal_reached),
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
            reset = 1;
            start_x = 8'd0;
            start_y = 8'd0;
            goal_x = 8'd0;
            goal_y = 8'd0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Start equals Goal");
            test_num = 1;
            reset_dut();

            start_x = 8'd50;
            start_y = 8'd50;
            goal_x = 8'd50;
            goal_y = 8'd50;


            repeat (10) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'd50, 8'd50);
        end
        endtask

    task testcase002;

        integer timeout;
        begin
            $display("Running Testcase 002: Small Distance Path");
            test_num = 2;
            reset_dut();

            start_x = 8'd10;
            start_y = 8'd10;
            goal_x = 8'd15;
            goal_y = 8'd15;

            timeout = 0;

            while (!goal_reached && timeout < 500) begin
                @(posedge clk);
                timeout = timeout + 1;
            end


            #1;



            check_outputs(1'b1, 8'd15, 8'd15);
        end
        endtask

    task testcase003;

        integer timeout;
        begin
            $display("Running Testcase 003: Moderate Distance Path");
            test_num = 3;
            reset_dut();

            start_x = 8'd20;
            start_y = 8'd20;
            goal_x = 8'd60;
            goal_y = 8'd60;

            timeout = 0;

            while (!goal_reached && timeout < 5000) begin
                @(posedge clk);
                timeout = timeout + 1;
            end


            #1;



            check_outputs(1'b1, 8'd60, 8'd60);
        end
        endtask

    task testcase004;

        integer timeout;
        begin
            $display("Running Testcase 004: Boundary Condition Path");
            test_num = 4;
            reset_dut();

            start_x = 8'd5;
            start_y = 8'd5;
            goal_x = 8'd250;
            goal_y = 8'd250;

            timeout = 0;

            while (!goal_reached && timeout < 10000) begin
                @(posedge clk);
                timeout = timeout + 1;
            end


            #1;



            check_outputs(1'b1, 8'd250, 8'd250);
        end
        endtask

    task testcase005;

        integer timeout;
        begin
            $display("Running Testcase 005: Reset and Recovery");
            test_num = 5;
            reset_dut();


            start_x = 8'd10;
            start_y = 8'd10;
            goal_x = 8'd100;
            goal_y = 8'd100;

            repeat (100) @(posedge clk);


            reset_dut();


            start_x = 8'd30;
            start_y = 8'd30;
            goal_x = 8'd35;
            goal_y = 8'd35;

            timeout = 0;
            while (!goal_reached && timeout < 1000) begin
                @(posedge clk);
                timeout = timeout + 1;
            end

            #1;


            check_outputs(1'b1, 8'd35, 8'd35);
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
        input expected_goal_reached;
        input [7:0] expected_path_x;
        input [7:0] expected_path_y;
        begin
            if (expected_goal_reached === (expected_goal_reached ^ goal_reached ^ expected_goal_reached) &&
                expected_path_x === (expected_path_x ^ path_x ^ expected_path_x) &&
                expected_path_y === (expected_path_y ^ path_y ^ expected_path_y)) begin
                $display("PASS");
                $display("  Outputs: goal_reached=%b, path_x=%h, path_y=%h",
                         goal_reached, path_x, path_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: goal_reached=%b, path_x=%h, path_y=%h",
                         expected_goal_reached, expected_path_x, expected_path_y);
                $display("  Got:      goal_reached=%b, path_x=%h, path_y=%h",
                         goal_reached, path_x, path_y);
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
        $dumpvars(0,clk, goal_x, goal_y, reset, start_x, start_y, goal_reached, path_x, path_y);
    end

endmodule
