`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [6:0] req_floor;
    reg reset;
    wire [1:0] Down;
    wire [1:0] Up;
    wire [1:0] door;
    wire [1:0] stop;
    wire [6:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .req_floor(req_floor),
        .reset(reset),
        .Down(Down),
        .Up(Up),
        .door(door),
        .stop(stop),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        req_floor = 7'd0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Running Testcase 001: Reset State");

        #1;


        check_outputs(2'b00, 2'b00, 2'b01, 2'b01, 7'd0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Running Testcase 002: Move Up to Floor 5");
        req_floor = 7'd5;

        repeat(10) @(posedge clk);

        #1;


        check_outputs(2'b00, 2'b00, 2'b01, 2'b01, 7'd5);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Running Testcase 003: Move Up to 10 then Down to 3");

        req_floor = 7'd10;
        repeat(15) @(posedge clk);

        req_floor = 7'd3;
        repeat(15) @(posedge clk);

        #1;


        check_outputs(2'b00, 2'b00, 2'b01, 2'b01, 7'd3);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Running Testcase 004: Request current floor (0)");
        req_floor = 7'd0;
        repeat(3) @(posedge clk);

        #1;


        check_outputs(2'b00, 2'b00, 2'b01, 2'b01, 7'd0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        $display("Running Testcase 005: Move to Floor 12");
        req_floor = 7'd12;
        repeat(20) @(posedge clk);

        #1;


        check_outputs(2'b00, 2'b00, 2'b01, 2'b01, 7'd12);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [1:0] expected_Down;
        input [1:0] expected_Up;
        input [1:0] expected_door;
        input [1:0] expected_stop;
        input [6:0] expected_y;
        begin
            if (expected_Down === (expected_Down ^ Down ^ expected_Down) &&
                expected_Up === (expected_Up ^ Up ^ expected_Up) &&
                expected_door === (expected_door ^ door ^ expected_door) &&
                expected_stop === (expected_stop ^ stop ^ expected_stop) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: Down=%h, Up=%h, door=%h, stop=%h, y=%h",
                         Down, Up, door, stop, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Down=%h, Up=%h, door=%h, stop=%h, y=%h",
                         expected_Down, expected_Up, expected_door, expected_stop, expected_y);
                $display("  Got:      Down=%h, Up=%h, door=%h, stop=%h, y=%h",
                         Down, Up, door, stop, y);
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
        $dumpvars(0,clk, req_floor, reset, Down, Up, door, stop, y);
    end

endmodule
