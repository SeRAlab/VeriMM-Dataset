`timescale 1ns/1ps

module rrt_tree_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] nearest_x;
    reg [7:0] nearest_y;
    reg [7:0] random_x;
    reg [7:0] random_y;
    reg rst;
    reg [7:0] threshold;
    wire connected;
    wire [7:0] new_x;
    wire [7:0] new_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rrt_tree dut (
        .clk(clk),
        .nearest_x(nearest_x),
        .nearest_y(nearest_y),
        .random_x(random_x),
        .random_y(random_y),
        .rst(rst),
        .threshold(threshold),
        .connected(connected),
        .new_x(new_x),
        .new_y(new_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            nearest_x = 0;
            nearest_y = 0;
            random_x = 0;
            random_y = 0;
            threshold = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %03d: Points are identical", test_num);
            nearest_x = 8'd50; nearest_y = 8'd50;
            random_x  = 8'd50; random_y  = 8'd50;
            threshold = 8'd10;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'd50, 8'd50);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %03d: Point within threshold (3-4-5 triangle)", test_num);
            nearest_x = 8'd10; nearest_y = 8'd10;
            random_x  = 8'd13; random_y  = 8'd14;
            threshold = 8'd10;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'd13, 8'd14);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %03d: Point outside threshold", test_num);
            nearest_x = 8'd100; nearest_y = 8'd100;
            random_x  = 8'd110; random_y  = 8'd110;
            threshold = 8'd10;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd0, 8'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %03d: Point exactly on boundary", test_num);
            nearest_x = 8'd20; nearest_y = 8'd20;
            random_x  = 8'd20; random_y  = 8'd28;
            threshold = 8'd8;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'd20, 8'd28);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %03d: Random point coordinates less than nearest", test_num);
            nearest_x = 8'd40; nearest_y = 8'd40;
            random_x  = 8'd37; random_y  = 8'd36;
            threshold = 8'd6;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 8'd37, 8'd36);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case %03d: Point very far away", test_num);
            nearest_x = 8'd0;   nearest_y = 8'd0;
            random_x  = 8'd255; random_y  = 8'd255;
            threshold = 8'd50;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd0, 8'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test Case %03d: Threshold is zero", test_num);
            nearest_x = 8'd15; nearest_y = 8'd15;
            random_x  = 8'd16; random_y  = 8'd15;
            threshold = 8'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0, 8'd0, 8'd0);
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
        input expected_connected;
        input [7:0] expected_new_x;
        input [7:0] expected_new_y;
        begin
            if (expected_connected === (expected_connected ^ connected ^ expected_connected) &&
                expected_new_x === (expected_new_x ^ new_x ^ expected_new_x) &&
                expected_new_y === (expected_new_y ^ new_y ^ expected_new_y)) begin
                $display("PASS");
                $display("  Outputs: connected=%b, new_x=%h, new_y=%h",
                         connected, new_x, new_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: connected=%b, new_x=%h, new_y=%h",
                         expected_connected, expected_new_x, expected_new_y);
                $display("  Got:      connected=%b, new_x=%h, new_y=%h",
                         connected, new_x, new_y);
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
        $dumpvars(0,clk, nearest_x, nearest_y, random_x, random_y, rst, threshold, connected, new_x, new_y);
    end

endmodule
