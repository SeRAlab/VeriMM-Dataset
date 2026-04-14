`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] parallel_in;
    reg shift_left;
    reg shift_right;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .shift_left(shift_left),
        .shift_right(shift_right),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            load = 1;
            parallel_in = 8'h00;
            shift_left = 0;
            shift_right = 0;
            @(negedge clk);
            load = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(negedge clk);
            parallel_in = 8'hA5;
            load = 1;
            @(negedge clk);
            load = 0;
            $display("Test Case 001: Parallel Load 8'hA5");
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(negedge clk);
            parallel_in = 8'h01;
            load = 1;
            @(negedge clk);
            load = 0;
            shift_left = 1;
            @(negedge clk);
            shift_left = 0;
            $display("Test Case 002: Shift Left 8'h01 -> 8'h02");
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(negedge clk);
            parallel_in = 8'h80;
            load = 1;
            @(negedge clk);
            load = 0;
            shift_right = 1;
            @(negedge clk);
            shift_right = 0;
            $display("Test Case 003: Shift Right 8'h80 -> 8'h40");
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(negedge clk);
            parallel_in = 8'h0F;
            load = 1;
            @(negedge clk);
            load = 0;
            shift_left = 1;
            repeat(4) @(negedge clk);
            shift_left = 0;
            $display("Test Case 004: Multi-bit Shift Left 8'h0F by 4 positions");
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(negedge clk);
            parallel_in = 8'hF0;
            load = 1;
            @(negedge clk);
            load = 0;
            shift_right = 1;
            repeat(4) @(negedge clk);
            shift_right = 0;
            $display("Test Case 005: Multi-bit Shift Right 8'hF0 by 4 positions");
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            @(negedge clk);
            parallel_in = 8'hFF;
            load = 1;
            @(negedge clk);
            load = 0;
            shift_left = 1;
            repeat(8) @(negedge clk);
            shift_left = 0;
            $display("Test Case 006: Shift Left 8'hFF 8 times (All Zeros)");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            @(negedge clk);
            parallel_in = 8'h55;
            load = 1;
            @(negedge clk);

            parallel_in = 8'hAA;
            load = 1;
            shift_left = 1;
            @(negedge clk);
            load = 0;
            shift_left = 0;
            $display("Test Case 007: Priority Check (Load 8'hAA during Shift)");
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            @(negedge clk);
            parallel_in = 8'hCC;
            load = 1;
            @(negedge clk);
            load = 0;
            shift_left = 0;
            shift_right = 0;
            repeat(3) @(negedge clk);
            $display("Test Case 008: Data Retention (No control signals)");
            #1;

            check_outputs(8'hCC);
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, load, parallel_in, shift_left, shift_right, data_out);
    end

endmodule
