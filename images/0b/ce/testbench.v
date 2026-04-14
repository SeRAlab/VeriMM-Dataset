`timescale 1ns/1ps

module slam_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg down;
    reg left;
    reg right;
    reg rst;
    reg up;
    reg [4:0] x_in;
    reg [4:0] y_in;
    wire [4:0] x_out;
    wire [4:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    slam_fsm dut (
        .clk(clk),
        .down(down),
        .left(left),
        .right(right),
        .rst(rst),
        .up(up),
        .x_in(x_in),
        .y_in(y_in),
        .x_out(x_out),
        .y_out(y_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [4:0] init_x;
        input [4:0] init_y;
        begin
            rst = 1;
            x_in = init_x;
            y_in = init_y;
            up = 0;
            down = 0;
            left = 0;
            right = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Movement - Move Right", test_num);
            reset_dut(5'd10, 5'd10);
            right = 1;
            @(posedge clk);
            #1 right = 0;
            @(posedge clk);
            #1;

            check_outputs(5'd11, 5'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Movement - Move Left", test_num);
            reset_dut(5'd10, 5'd10);
            left = 1;
            @(posedge clk);
            #1 left = 0;
            @(posedge clk);
            #1;

            check_outputs(5'd9, 5'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Basic Movement - Move Up", test_num);
            reset_dut(5'd10, 5'd10);
            up = 1;
            @(posedge clk);
            #1 up = 0;
            @(posedge clk);
            #1;

            check_outputs(5'd10, 5'd11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Basic Movement - Move Down", test_num);
            reset_dut(5'd10, 5'd10);
            down = 1;
            @(posedge clk);
            #1 down = 0;
            @(posedge clk);
            #1;

            check_outputs(5'd10, 5'd9);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Boundary Check - Minimum X (Left)", test_num);
            reset_dut(5'd0, 5'd10);
            left = 1;
            @(posedge clk);
            #1 left = 0;
            @(posedge clk);
            #1;

            check_outputs(5'd0, 5'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Boundary Check - Minimum Y (Down)", test_num);
            reset_dut(5'd10, 5'd0);
            down = 1;
            @(posedge clk);
            #1 down = 0;
            @(posedge clk);
            #1;

            check_outputs(5'd10, 5'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Boundary Check - Maximum X (Right)", test_num);
            reset_dut(5'd31, 5'd15);
            right = 1;
            @(posedge clk);
            #1 right = 0;
            @(posedge clk);
            #1;

            check_outputs(5'd31, 5'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Boundary Check - Maximum Y (Up)", test_num);
            reset_dut(5'd15, 5'd31);
            up = 1;
            @(posedge clk);
            #1 up = 0;
            @(posedge clk);
            #1;

            check_outputs(5'd15, 5'd31);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Sequential Movement (Diagonal Path)", test_num);
            reset_dut(5'd5, 5'd5);

            right = 1; @(posedge clk); #1; right = 0;

            up = 1; @(posedge clk); #1; up = 0;

            right = 1; @(posedge clk); #1; right = 0;
            @(posedge clk);
            #1;

            check_outputs(5'd7, 5'd6);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: No Movement Signal Retains Position", test_num);
            reset_dut(5'd20, 5'd20);
            up = 0; down = 0; left = 0; right = 0;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(5'd20, 5'd20);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("slam_fsm Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [4:0] expected_x_out;
        input [4:0] expected_y_out;
        begin
            if (expected_x_out === (expected_x_out ^ x_out ^ expected_x_out) &&
                expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: x_out=%h, y_out=%h",
                         x_out, y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_out=%h, y_out=%h",
                         expected_x_out, expected_y_out);
                $display("  Got:      x_out=%h, y_out=%h",
                         x_out, y_out);
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
        $dumpvars(0,clk, down, left, right, rst, up, x_in, y_in, x_out, y_out);
    end

endmodule
