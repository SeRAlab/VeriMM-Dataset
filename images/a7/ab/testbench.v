`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A;
    reg B;
    reg CLOCK;
    reg RESET;
    wire COUNT_ENABLE;
    wire DIRECTION;
    wire [3:0] SPEED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLOCK(CLOCK),
        .RESET(RESET),
        .COUNT_ENABLE(COUNT_ENABLE),
        .DIRECTION(DIRECTION),
        .SPEED(SPEED)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK = 0;
        forever #5 CLOCK = ~CLOCK;
    end

        task reset_dut;

        begin
            RESET = 1;
            A = 0;
            B = 0;
            repeat(3) @(posedge CLOCK);
            #1;
            RESET = 0;
            repeat(2) @(posedge CLOCK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            repeat(5) @(posedge CLOCK);

            #1;


            check_outputs(1'b0, DIRECTION, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge CLOCK);
            A = 1; B = 0;
            repeat(3) @(posedge CLOCK);
            #1;

            check_outputs(1'b1, 1'b1, 4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge CLOCK);
            A = 0; B = 1;
            repeat(3) @(posedge CLOCK);
            #1;

            check_outputs(1'b1, 1'b0, 4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(posedge CLOCK);
            A = 1; B = 0;
            repeat(5) @(posedge CLOCK);

            B = 1;
            repeat(3) @(posedge CLOCK);
            #1;

            check_outputs(1'b1, 1'b1, 4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(posedge CLOCK);
            A = 0; B = 1;
            repeat(5) @(posedge CLOCK);

            A = 1;
            repeat(3) @(posedge CLOCK);
            #1;

            check_outputs(1'b1, 1'b0, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            @(posedge CLOCK); A = 1; B = 0;
            repeat(5) @(posedge CLOCK);

            A = 1; B = 1;
            repeat(5) @(posedge CLOCK);

            A = 0; B = 1;
            repeat(3) @(posedge CLOCK);
            #1;

            check_outputs(1'b1, 1'b1, 4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            @(posedge CLOCK); A = 0; B = 1;
            repeat(5) @(posedge CLOCK);

            A = 1; B = 1;
            repeat(5) @(posedge CLOCK);

            A = 1; B = 0;
            repeat(3) @(posedge CLOCK);
            #1;

            check_outputs(1'b1, 1'b0, 4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            @(posedge CLOCK);
            A = 1; B = 0;
            repeat(10) @(posedge CLOCK);
            #1;

            check_outputs(1'b0, DIRECTION, 4'b0000);
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
        input expected_COUNT_ENABLE;
        input expected_DIRECTION;
        input [3:0] expected_SPEED;
        begin
            if (expected_COUNT_ENABLE === (expected_COUNT_ENABLE ^ COUNT_ENABLE ^ expected_COUNT_ENABLE) &&
                expected_DIRECTION === (expected_DIRECTION ^ DIRECTION ^ expected_DIRECTION) &&
                expected_SPEED === (expected_SPEED ^ SPEED ^ expected_SPEED)) begin
                $display("PASS");
                $display("  Outputs: COUNT_ENABLE=%b, DIRECTION=%b, SPEED=%h",
                         COUNT_ENABLE, DIRECTION, SPEED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUNT_ENABLE=%b, DIRECTION=%b, SPEED=%h",
                         expected_COUNT_ENABLE, expected_DIRECTION, expected_SPEED);
                $display("  Got:      COUNT_ENABLE=%b, DIRECTION=%b, SPEED=%h",
                         COUNT_ENABLE, DIRECTION, SPEED);
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
        $dumpvars(0,A, B, CLOCK, RESET, COUNT_ENABLE, DIRECTION, SPEED);
    end

endmodule
