`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg bit_clk_falling_edge;
    reg bit_clk_rising_edge;
    reg clk;
    reg left_right_clk_falling_edge;
    reg left_right_clk_rising_edge;
    reg reset;
    wire counting;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bit_clk_falling_edge(bit_clk_falling_edge),
        .bit_clk_rising_edge(bit_clk_rising_edge),
        .clk(clk),
        .left_right_clk_falling_edge(left_right_clk_falling_edge),
        .left_right_clk_rising_edge(left_right_clk_rising_edge),
        .reset(reset),
        .counting(counting)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            clear_pulses();
            repeat (2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task clear_pulses;

        begin
            bit_clk_falling_edge = 0;
            bit_clk_rising_edge = 0;
            left_right_clk_falling_edge = 0;
            left_right_clk_rising_edge = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: LR Clock Rising Edge Trigger", test_num);
            reset_dut();
            @(posedge clk);
            left_right_clk_rising_edge = 1;
            @(posedge clk);
            left_right_clk_rising_edge = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: LR Clock Falling Edge Trigger", test_num);
            reset_dut();
            @(posedge clk);
            left_right_clk_falling_edge = 1;
            @(posedge clk);
            left_right_clk_falling_edge = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Single Bit Clock Decrement", test_num);
            reset_dut();
            @(posedge clk);
            left_right_clk_rising_edge = 1;
            @(posedge clk);
            left_right_clk_rising_edge = 0;
            @(posedge clk);


            bit_clk_falling_edge = 1;
            @(posedge clk);
            bit_clk_falling_edge = 0;
            @(posedge clk);


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %03d: Counting to Zero", test_num);
            reset_dut();
            @(posedge clk);
            left_right_clk_rising_edge = 1;
            @(posedge clk);
            left_right_clk_rising_edge = 0;



            for (i = 0; i < 128; i = i + 1) begin
                @(posedge clk);
                bit_clk_falling_edge = 1;
                @(posedge clk);
                bit_clk_falling_edge = 0;
            end

            repeat (2) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Reset during active count", test_num);
            reset_dut();
            @(posedge clk);
            left_right_clk_falling_edge = 1;
            @(posedge clk);
            left_right_clk_falling_edge = 0;

            repeat (5) begin
                @(posedge clk);
                bit_clk_falling_edge = 1;
                @(posedge clk);
                bit_clk_falling_edge = 0;
            end


            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);

            #1;


            check_outputs(1'b0);
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
        input expected_counting;
        begin
            if (expected_counting === (expected_counting ^ counting ^ expected_counting)) begin
                $display("PASS");
                $display("  Outputs: counting=%b",
                         counting);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counting=%b",
                         expected_counting);
                $display("  Got:      counting=%b",
                         counting);
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
        $dumpvars(0,bit_clk_falling_edge, bit_clk_rising_edge, clk, left_right_clk_falling_edge, left_right_clk_rising_edge, reset, counting);
    end

endmodule
