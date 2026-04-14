`timescale 1ns/1ps

module robot_navigation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] direction;
    reg rst;
    wire [3:0] position_x;
    wire [3:0] position_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    robot_navigation dut (
        .clk(clk),
        .direction(direction),
        .rst(rst),
        .position_x(position_x),
        .position_y(position_y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            direction = 2'b00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Initial state after reset", test_num);
            reset_dut();
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Basic movement (Up and Right)", test_num);
            reset_dut();

            direction = 2'b11; @(posedge clk); @(posedge clk);

            direction = 2'b00; @(posedge clk); @(posedge clk); @(posedge clk);
            #1; #1;
 check_outputs(4'd2, 4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Movement from offset (Down and Left)", test_num);
            reset_dut();

            direction = 2'b11; repeat(5) @(posedge clk);
            direction = 2'b00; repeat(5) @(posedge clk);

            direction = 2'b01; repeat(2) @(posedge clk);
            direction = 2'b10; repeat(1) @(posedge clk);
            #1; #1;
 check_outputs(4'd4, 4'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: X-axis positive wrap-around", test_num);
            reset_dut();
            direction = 2'b11;
            repeat(16) @(posedge clk);
            #1; #1;
 check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Y-axis positive wrap-around", test_num);
            reset_dut();
            direction = 2'b00;
            repeat(17) @(posedge clk);
            #1; #1;
 check_outputs(4'd0, 4'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: X-axis negative wrap-around", test_num);
            reset_dut();
            direction = 2'b10;
            @(posedge clk);
            #1; #1;
 check_outputs(4'd15, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Y-axis negative wrap-around", test_num);
            reset_dut();
            direction = 2'b01;
            @(posedge clk);
            #1; #1;
 check_outputs(4'd0, 4'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Diagonal wrap-around to corner", test_num);
            reset_dut();
            direction = 2'b10; @(posedge clk);
            direction = 2'b01; @(posedge clk);
            #1; #1;
 check_outputs(4'd15, 4'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("robot_navigation Testbench");
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
        input [3:0] expected_position_x;
        input [3:0] expected_position_y;
        begin
            if (expected_position_x === (expected_position_x ^ position_x ^ expected_position_x) &&
                expected_position_y === (expected_position_y ^ position_y ^ expected_position_y)) begin
                $display("PASS");
                $display("  Outputs: position_x=%h, position_y=%h",
                         position_x, position_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: position_x=%h, position_y=%h",
                         expected_position_x, expected_position_y);
                $display("  Got:      position_x=%h, position_y=%h",
                         position_x, position_y);
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
        $dumpvars(0,clk, direction, rst, position_x, position_y);
    end

endmodule
