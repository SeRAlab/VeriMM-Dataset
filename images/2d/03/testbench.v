`timescale 1ns/1ps

module slam_position_tracker_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] direction;
    reg rst;
    wire [2:0] x_pos;
    wire [2:0] y_pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_position_tracker dut (
        .clk(clk),
        .direction(direction),
        .rst(rst),
        .x_pos(x_pos),
        .y_pos(y_pos)
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
            $display("Testcase 001: Initial Reset Position");
            reset_dut();
            #1;

            check_outputs(3'd0, 3'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Move Right twice");
            reset_dut();
            direction = DIR_RIGHT;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(3'd2, 3'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Move Up three times");
            reset_dut();
            direction = DIR_UP;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(3'd0, 3'd3);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Wrap Around Right (x: 0->1->2->3->4->0)");
            reset_dut();
            direction = DIR_RIGHT;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(3'd0, 3'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Wrap Around Left (x: 0->4)");
            reset_dut();
            direction = DIR_LEFT;
            @(posedge clk);
            #1 #1;
 check_outputs(3'd4, 3'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Wrap Around Down (y: 0->4)");
            reset_dut();
            direction = DIR_DOWN;
            @(posedge clk);
            #1 #1;
 check_outputs(3'd0, 3'd4);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Complex Path Sequence");
            reset_dut();
            direction = DIR_RIGHT; @(posedge clk);
            direction = DIR_RIGHT; @(posedge clk);
            direction = DIR_UP;    @(posedge clk);
            direction = DIR_RIGHT; @(posedge clk);
            direction = DIR_DOWN;  @(posedge clk);
            #1 #1;
 check_outputs(3'd3, 3'd0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Double Backward Wrap");
            reset_dut();
            direction = DIR_LEFT;
            @(posedge clk);
            @(posedge clk);
            direction = DIR_DOWN;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(3'd3, 3'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slam_position_tracker Testbench");
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
        input [2:0] expected_x_pos;
        input [2:0] expected_y_pos;
        begin
            if (expected_x_pos === (expected_x_pos ^ x_pos ^ expected_x_pos) &&
                expected_y_pos === (expected_y_pos ^ y_pos ^ expected_y_pos)) begin
                $display("PASS");
                $display("  Outputs: x_pos=%h, y_pos=%h",
                         x_pos, y_pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_pos=%h, y_pos=%h",
                         expected_x_pos, expected_y_pos);
                $display("  Got:      x_pos=%h, y_pos=%h",
                         x_pos, y_pos);
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
        $dumpvars(0,clk, direction, rst, x_pos, y_pos);
    end

endmodule
