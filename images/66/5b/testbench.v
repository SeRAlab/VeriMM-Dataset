`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] dirtime;
    reg enable;
    reg [4:0] steptime;
    reg [1:0] tap;
    reg [10:0] velocity;
    wire dir;
    wire [21:0] position;
    wire step;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dirtime(dirtime),
        .enable(enable),
        .steptime(steptime),
        .tap(tap),
        .velocity(velocity),
        .dir(dir),
        .position(position),
        .step(step)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            velocity = 0;
            dirtime = 0;
            steptime = 0;
            tap = 0;
            repeat (5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            enable = 0;
            velocity = 11'h064;
            dirtime = 5'd5;
            steptime = 5'd5;

            repeat (20) @(posedge clk);

            $display("Testcase 001: Checking idle state (Enable=0)");

            #1;


            check_outputs(1'b0, 22'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            enable = 1;
            velocity = 11'h00A;
            dirtime = 5'd2;
            steptime = 5'd4;
            tap = 2'b00;


            repeat (50) @(posedge clk);

            $display("Testcase 002: Basic Forward Motion (Positive Velocity)");


            if (position > 0 && dir == 0) begin
                pass_count = pass_count + 1;
                $display("PASS: Position changed to %h, Dir=%b", position, dir);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Position=%h, Dir=%b", position, dir);
            end
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            enable = 1;
            velocity = 11'h010;
            steptime = 5'd2;
            dirtime = 5'd10;
            repeat (20) @(posedge clk);


            velocity = 11'h7F0;


            repeat (100) @(posedge clk);

            $display("Testcase 003: Direction Change (Negative Velocity)");


            if (dir == 1) begin
                pass_count = pass_count + 1;
                $display("PASS: Direction flipped to 1, Position=%h", position);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Direction stayed %b", dir);
            end
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            enable = 1;
            velocity = 11'h020;
            steptime = 5'd31;
            dirtime = 5'd5;

            repeat (100) @(posedge clk);

            $display("Testcase 004: High Steptime Timing");


            if (position > 0) begin
                pass_count = pass_count + 1;
                $display("PASS: Stepping occurred with high steptime. Position=%h", position);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: No movement detected with high steptime.");
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            enable = 1;
            velocity = 11'h000;
            steptime = 5'd2;
            dirtime = 5'd2;

            repeat (50) @(posedge clk);

            $display("Testcase 005: Zero Velocity Behavior");
            #1;

            check_outputs(dir, 22'h0, 1'b0);
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
        input expected_dir;
        input [21:0] expected_position;
        input expected_step;
        begin
            if (expected_dir === (expected_dir ^ dir ^ expected_dir) &&
                expected_position === (expected_position ^ position ^ expected_position) &&
                expected_step === (expected_step ^ step ^ expected_step)) begin
                $display("PASS");
                $display("  Outputs: dir=%b, position=%h, step=%b",
                         dir, position, step);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dir=%b, position=%h, step=%b",
                         expected_dir, expected_position, expected_step);
                $display("  Got:      dir=%b, position=%h, step=%b",
                         dir, position, step);
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
        $dumpvars(0,clk, dirtime, enable, steptime, tap, velocity, dir, position, step);
    end

endmodule
