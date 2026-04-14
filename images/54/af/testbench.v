`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [1:0] length;
    reg reset;
    reg start;
    wire is_invincible;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .length(length),
        .reset(reset),
        .start(start),
        .is_invincible(is_invincible)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            length = 2'b00;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verification of reset state", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Activation check with length 1", test_num);
            reset_dut();
            length = 2'b01;
            @(posedge clock);
            start = 1;
            @(posedge clock);
            start = 0;

            repeat(2) @(posedge clock);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Activation check with length 2", test_num);
            reset_dut();
            length = 2'b10;
            @(posedge clock);
            start = 1;
            @(posedge clock);
            start = 0;

            repeat(2) @(posedge clock);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Reset override during active timing", test_num);
            reset_dut();
            length = 2'b01;
            @(posedge clock);
            start = 1;
            @(posedge clock);
            start = 0;
            repeat(5) @(posedge clock);


            reset = 1;
            @(posedge clock);
            reset = 0;
            @(posedge clock);


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Start with length 0", test_num);
            reset_dut();
            length = 2'b00;
            @(posedge clock);
            start = 1;
            @(posedge clock);
            start = 0;
            repeat(2) @(posedge clock);


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Persistence check", test_num);
            reset_dut();
            length = 2'b11;
            @(posedge clock);
            start = 1;
            @(posedge clock);
            start = 0;

            repeat(100) @(posedge clock);
            #1;

            check_outputs(1'b1);
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
        input expected_is_invincible;
        begin
            if (expected_is_invincible === (expected_is_invincible ^ is_invincible ^ expected_is_invincible)) begin
                $display("PASS");
                $display("  Outputs: is_invincible=%b",
                         is_invincible);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: is_invincible=%b",
                         expected_is_invincible);
                $display("  Got:      is_invincible=%b",
                         is_invincible);
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
        $dumpvars(0,clock, length, reset, start, is_invincible);
    end

endmodule
