`timescale 1ns/1ps

module rrt_algorithm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] goal_x;
    reg [7:0] goal_y;
    reg reset;
    reg [7:0] start_x;
    reg [7:0] start_y;
    wire path_found;
    wire [7:0] path_x;
    wire [7:0] path_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_algorithm dut (
        .clk(clk),
        .goal_x(goal_x),
        .goal_y(goal_y),
        .reset(reset),
        .start_x(start_x),
        .start_y(start_y),
        .path_found(path_found),
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
            start_x = 0;
            start_y = 0;
            goal_x = 0;
            goal_y = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Start equals Goal", test_num);
            reset_dut();

            start_x = 8'd50;
            start_y = 8'd50;
            goal_x  = 8'd50;
            goal_y  = 8'd50;


            repeat (100) begin
                if (path_found) break;
                @(posedge clk);
            end


            #1;



            check_outputs(1'b1, 8'd50, 8'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Short Distance (Diagonal)", test_num);
            reset_dut();

            start_x = 8'd10;
            start_y = 8'd10;
            goal_x  = 8'd25;
            goal_y  = 8'd25;


            repeat (1000) begin
                if (path_found) break;
                @(posedge clk);
            end

            #1;


            check_outputs(1'b1, 8'd25, 8'd25);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Long Distance (Horizontal)", test_num);
            reset_dut();

            start_x = 8'd10;
            start_y = 8'd128;
            goal_x  = 8'd200;
            goal_y  = 8'd128;


            repeat (5000) begin
                if (path_found) break;
                @(posedge clk);
            end

            #1;


            check_outputs(1'b1, 8'd200, 8'd128);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Exploration (Corner to Corner)", test_num);
            reset_dut();

            start_x = 8'd5;
            start_y = 8'd5;
            goal_x  = 8'd250;
            goal_y  = 8'd250;


            repeat (10000) begin
                if (path_found) break;
                @(posedge clk);
            end

            #1;


            check_outputs(1'b1, 8'd250, 8'd250);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mid-operation Reset", test_num);
            reset_dut();

            start_x = 8'd0;
            start_y = 8'd0;
            goal_x  = 8'd100;
            goal_y  = 8'd100;


            repeat (50) @(posedge clk);


            reset = 1;
            repeat (5) @(posedge clk);


            #1;



            check_outputs(1'b0, 8'd0, 8'd0);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rrt_algorithm Testbench");
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
        input expected_path_found;
        input [7:0] expected_path_x;
        input [7:0] expected_path_y;
        begin
            if (expected_path_found === (expected_path_found ^ path_found ^ expected_path_found) &&
                expected_path_x === (expected_path_x ^ path_x ^ expected_path_x) &&
                expected_path_y === (expected_path_y ^ path_y ^ expected_path_y)) begin
                $display("PASS");
                $display("  Outputs: path_found=%b, path_x=%h, path_y=%h",
                         path_found, path_x, path_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: path_found=%b, path_x=%h, path_y=%h",
                         expected_path_found, expected_path_x, expected_path_y);
                $display("  Got:      path_found=%b, path_x=%h, path_y=%h",
                         path_found, path_x, path_y);
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
        $dumpvars(0,clk, goal_x, goal_y, reset, start_x, start_y, path_found, path_x, path_y);
    end

endmodule
