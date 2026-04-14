`timescale 1ns/1ps

module RRT_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] goal_x;
    reg [7:0] goal_y;
    reg [7:0] rand_x;
    reg [7:0] rand_y;
    reg rst;
    reg [7:0] start_x;
    reg [7:0] start_y;
    wire found;
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
        .rand_x(rand_x),
        .rand_y(rand_y),
        .rst(rst),
        .start_x(start_x),
        .start_y(start_y),
        .found(found),
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
            rand_x = 0;
            rand_y = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Valid path within short range", test_num);
            reset_dut();
            start_x = 8'd10;  start_y = 8'd10;
            rand_x  = 8'd15;  rand_y  = 8'd15;
            goal_x  = 8'd20;  goal_y  = 8'd20;


            repeat(10) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'd20, 8'd20);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random point too far from Start", test_num);
            reset_dut();
            start_x = 8'd10;   start_y = 8'd10;
            rand_x  = 8'd100;  rand_y  = 8'd100;
            goal_x  = 8'd105;  goal_y  = 8'd105;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(1'b0, 8'd0, 8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Goal point too far from Random point", test_num);
            reset_dut();
            start_x = 8'd50;   start_y = 8'd50;
            rand_x  = 8'd52;   rand_y  = 8'd52;
            goal_x  = 8'd150;  goal_y  = 8'd150;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(1'b0, 8'd0, 8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All points at same location", test_num);
            reset_dut();
            start_x = 8'd128; start_y = 8'd128;
            rand_x  = 8'd128; rand_y  = 8'd128;
            goal_x  = 8'd128; goal_y  = 8'd128;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'd128, 8'd128);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Valid path at medium range threshold", test_num);
            reset_dut();
            start_x = 8'd20;  start_y = 8'd20;
            rand_x  = 8'd30;  rand_y  = 8'd25;
            goal_x  = 8'd40;  goal_y  = 8'd30;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b1, 8'd40, 8'd30);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Coordinate subtraction order test", test_num);
            reset_dut();
            start_x = 8'd10;  start_y = 8'd10;
            rand_x  = 8'd5;   rand_y  = 8'd5;
            goal_x  = 8'd1;   goal_y  = 8'd1;

            repeat(10) @(posedge clk);


            #1;



            check_outputs(1'b1, 8'd1, 8'd1);
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
        input expected_found;
        input [7:0] expected_path_x;
        input [7:0] expected_path_y;
        begin
            if (expected_found === (expected_found ^ found ^ expected_found) &&
                expected_path_x === (expected_path_x ^ path_x ^ expected_path_x) &&
                expected_path_y === (expected_path_y ^ path_y ^ expected_path_y)) begin
                $display("PASS");
                $display("  Outputs: found=%b, path_x=%h, path_y=%h",
                         found, path_x, path_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: found=%b, path_x=%h, path_y=%h",
                         expected_found, expected_path_x, expected_path_y);
                $display("  Got:      found=%b, path_x=%h, path_y=%h",
                         found, path_x, path_y);
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
        $dumpvars(0,clk, goal_x, goal_y, rand_x, rand_y, rst, start_x, start_y, found, path_x, path_y);
    end

endmodule
