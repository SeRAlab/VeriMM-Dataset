`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [3:0] parallel_in;
    reg reset;
    reg shift_left;
    reg shift_right;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .reset(reset),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            load = 0;
            shift_left = 0;
            shift_right = 0;
            parallel_in = 4'b0000;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case 001: Parallel Load 4'b1010");
            @(negedge clk);
            load = 1;
            parallel_in = 4'b1010;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case 002: Load 4'b0001 and Shift Left twice");
            @(negedge clk);
            load = 1;
            parallel_in = 4'b0001;
            @(negedge clk);
            load = 0;
            shift_left = 1;
            @(negedge clk);
            @(negedge clk);
            shift_left = 0;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case 003: Load 4'b1000 and Shift Right twice");
            @(negedge clk);
            load = 1;
            parallel_in = 4'b1000;
            @(negedge clk);
            load = 0;
            shift_right = 1;
            @(negedge clk);
            @(negedge clk);
            shift_right = 0;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case 004: Priority Test - Load and Shift Left at once");
            @(negedge clk);
            load = 1;
            parallel_in = 4'b1111;
            @(negedge clk);

            load = 1;
            parallel_in = 4'b0101;
            shift_left = 1;
            @(negedge clk);
            load = 0;
            shift_left = 0;

            #1;


            check_outputs(4'b0101);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case 005: Shift Left all bits out");
            @(negedge clk);
            load = 1;
            parallel_in = 4'b1100;
            @(negedge clk);
            load = 0;
            shift_left = 1;
            repeat(4) @(negedge clk);
            shift_left = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case 006: Shift Right then Shift Left");
            @(negedge clk);
            load = 1;
            parallel_in = 4'b1100;
            @(negedge clk);
            load = 0;
            shift_right = 1;
            @(negedge clk);
            shift_right = 0;
            shift_left = 1;
            @(negedge clk);
            shift_left = 0;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test Case 007: Synchronous Reset during Shift");
            @(negedge clk);
            load = 1;
            parallel_in = 4'b1111;
            @(negedge clk);
            load = 0;
            shift_right = 1;
            reset = 1;
            @(negedge clk);
            reset = 0;
            shift_right = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, load, parallel_in, reset, shift_left, shift_right, q);
    end

endmodule
