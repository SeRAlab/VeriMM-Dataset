`timescale 1ns/1ps

module slam_robot_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg move_forward;
    reg reset;
    reg rotate_left;
    reg rotate_right;
    wire [1:0] direction;
    wire [3:0] position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_robot dut (
        .clk(clk),
        .move_forward(move_forward),
        .reset(reset),
        .rotate_left(rotate_left),
        .rotate_right(rotate_right),
        .direction(direction),
        .position(position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            move_forward = 0;
            rotate_left = 0;
            rotate_right = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Move Forward North", test_num);
            reset_dut();
            move_forward = 1;
            @(posedge clk);
            #1 move_forward = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b00, 4'b0100);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rotate Right and Move East", test_num);
            reset_dut();
            rotate_right = 1;
            @(posedge clk);
            #1 rotate_right = 0;
            move_forward = 1;
            @(posedge clk);
            #1 move_forward = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b01, 4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rotate Left and Move West (Wrap)", test_num);
            reset_dut();
            rotate_left = 1;
            @(posedge clk);
            #1 rotate_left = 0;
            move_forward = 1;
            @(posedge clk);
            #1 move_forward = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b11, 4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Move South (Wrap)", test_num);
            reset_dut();
            rotate_right = 1;
            @(posedge clk);
            #1;
            @(posedge clk);
            #1 rotate_right = 0;
            move_forward = 1;
            @(posedge clk);
            #1 move_forward = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b10, 4'b1100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full 360 Degree Rotation", test_num);
            reset_dut();
            rotate_right = 1;
            repeat(4) @(posedge clk);
            #1 rotate_right = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b00, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex Path (Move N, Move E)", test_num);
            reset_dut();

            move_forward = 1;
            @(posedge clk);
            #1 move_forward = 0;

            rotate_right = 1;
            @(posedge clk);
            #1 rotate_right = 0;

            move_forward = 1;
            @(posedge clk);
            #1 move_forward = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(2'b01, 4'b0101);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slam_robot Testbench");
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
        input [1:0] expected_direction;
        input [3:0] expected_position;
        begin
            if (expected_direction === (expected_direction ^ direction ^ expected_direction) &&
                expected_position === (expected_position ^ position ^ expected_position)) begin
                $display("PASS");
                $display("  Outputs: direction=%h, position=%h",
                         direction, position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: direction=%h, position=%h",
                         expected_direction, expected_position);
                $display("  Got:      direction=%h, position=%h",
                         direction, position);
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
        $dumpvars(0,clk, move_forward, reset, rotate_left, rotate_right, direction, position);
    end

endmodule
