`timescale 1ns/1ps

module robot_movement_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] direction;
    reg rst;
    wire [1:0] pos_x;
    wire [1:0] pos_y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    robot_movement dut (
        .clk(clk),
        .direction(direction),
        .rst(rst),
        .pos_x(pos_x),
        .pos_y(pos_y)
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
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Initial Reset Position");
            reset_dut();
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Single Move Right");
            reset_dut();
            direction = MOVE_RIGHT;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01, 2'b00);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Single Move Up");
            reset_dut();
            direction = MOVE_UP;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 2'b01);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Boundary Check (Origin Clamp)");
            reset_dut();
            direction = MOVE_LEFT;
            @(posedge clk);
            #1;
            direction = MOVE_DOWN;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Reach Right Boundary");
            reset_dut();
            direction = MOVE_RIGHT;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11, 2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Reach Top Boundary");
            reset_dut();
            direction = MOVE_UP;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 2'b11);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Top-Right Corner Clamping");
            reset_dut();

            direction = MOVE_RIGHT;
            repeat(3) @(posedge clk);

            direction = MOVE_UP;
            repeat(3) @(posedge clk);

            direction = MOVE_RIGHT;
            @(posedge clk);
            direction = MOVE_UP;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11, 2'b11);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: Zig-Zag Movement");
            reset_dut();

            direction = MOVE_RIGHT; @(posedge clk);
            direction = MOVE_UP;    @(posedge clk);
            direction = MOVE_RIGHT; @(posedge clk);
            direction = MOVE_UP;    @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10, 2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("robot_movement Testbench");
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
        input [1:0] expected_pos_x;
        input [1:0] expected_pos_y;
        begin
            if (expected_pos_x === (expected_pos_x ^ pos_x ^ expected_pos_x) &&
                expected_pos_y === (expected_pos_y ^ pos_y ^ expected_pos_y)) begin
                $display("PASS");
                $display("  Outputs: pos_x=%h, pos_y=%h",
                         pos_x, pos_y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pos_x=%h, pos_y=%h",
                         expected_pos_x, expected_pos_y);
                $display("  Got:      pos_x=%h, pos_y=%h",
                         pos_x, pos_y);
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
        $dumpvars(0,clk, direction, rst, pos_x, pos_y);
    end

endmodule
