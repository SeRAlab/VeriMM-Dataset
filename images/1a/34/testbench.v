`timescale 1ns/1ps

module robot_navigation_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] direction;
    reg enable;
    reg rst;
    wire [1:0] col;
    wire [1:0] row;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    robot_navigation dut (
        .clk(clk),
        .direction(direction),
        .enable(enable),
        .rst(rst),
        .col(col),
        .row(row)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        enable = 0;
        direction = 2'b00;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Initial State After Reset");
        reset_dut();
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Moving Right and Down");
        reset_dut();
        @(posedge clk);
        enable = 1; direction = DIR_RIGHT;
        @(posedge clk);
        enable = 1; direction = DIR_DOWN;
        @(posedge clk);
        enable = 0;
        #1;

        check_outputs(2'b01, 2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Enable Signal Logic");
        reset_dut();
        @(posedge clk);
        enable = 1; direction = DIR_RIGHT;
        @(posedge clk);
        enable = 0; direction = DIR_RIGHT;
        @(posedge clk);
        enable = 0; direction = DIR_DOWN;
        @(posedge clk);
        #1;

        check_outputs(2'b01, 2'b00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Boundary check at (0,0)");
        reset_dut();
        @(posedge clk);
        enable = 1; direction = DIR_UP;
        @(posedge clk);
        enable = 1; direction = DIR_LEFT;
        @(posedge clk);
        #1;

        check_outputs(2'b00, 2'b00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Boundary check at (3,3)");
        reset_dut();
        enable = 1;

        direction = DIR_RIGHT; repeat(5) @(posedge clk);

        direction = DIR_DOWN;  repeat(5) @(posedge clk);
        enable = 0;
        #1;

        check_outputs(2'b11, 2'b11);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Complex path traversal");
        reset_dut();
        enable = 1;
        direction = DIR_RIGHT; @(posedge clk);
        direction = DIR_RIGHT; @(posedge clk);
        direction = DIR_DOWN;  @(posedge clk);
        direction = DIR_LEFT;  @(posedge clk);
        direction = DIR_UP;    @(posedge clk);
        enable = 0;
        #1;

        check_outputs(2'b01, 2'b00);
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
        input [1:0] expected_col;
        input [1:0] expected_row;
        begin
            if (expected_col === (expected_col ^ col ^ expected_col) &&
                expected_row === (expected_row ^ row ^ expected_row)) begin
                $display("PASS");
                $display("  Outputs: col=%h, row=%h",
                         col, row);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: col=%h, row=%h",
                         expected_col, expected_row);
                $display("  Got:      col=%h, row=%h",
                         col, row);
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
        $dumpvars(0,clk, direction, enable, rst, col, row);
    end

endmodule
