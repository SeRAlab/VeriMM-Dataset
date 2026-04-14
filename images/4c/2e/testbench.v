`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data;
    reg reset;
    reg select;
    wire [3:0] counter_out;
    wire [2:0] shift_register_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .select(select),
        .counter_out(counter_out),
        .shift_register_out(shift_register_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data = 0;
            select = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Initial Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0, 3'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Counter Incrementing", test_num);
            reset_dut();
            select = 1;
            repeat (5) @(posedge clk);
            #1 #1;
 check_outputs(4'h5, 3'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Register Operation", test_num);
            reset_dut();
            select = 0;

            data = 1; @(posedge clk);
            data = 0; @(posedge clk);
            data = 1; @(posedge clk);
            #1 #1;
 check_outputs(4'h0, 3'b101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Operations", test_num);
            reset_dut();

            select = 1;
            repeat (2) @(posedge clk);

            select = 0;
            data = 1; @(posedge clk);
            data = 1; @(posedge clk);

            select = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h3, 3'b011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Counter Overflow (4-bit)", test_num);
            reset_dut();
            select = 1;
            repeat (16) @(posedge clk);
            #1 #1;
 check_outputs(4'h0, 3'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Register Depth Check", test_num);
            reset_dut();
            select = 0;

            data = 1; @(posedge clk);
            data = 0; @(posedge clk);
            data = 1; @(posedge clk);
            data = 1; @(posedge clk);
            #1 #1;
 check_outputs(4'h0, 3'b011);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Persistence of values", test_num);
            reset_dut();

            select = 1;
            repeat (7) @(posedge clk);

            select = 0;
            data = 1; @(posedge clk);
            data = 0; @(posedge clk);
            data = 1; @(posedge clk);


            #1 #1;
 check_outputs(4'h7, 3'b101);
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
        input [3:0] expected_counter_out;
        input [2:0] expected_shift_register_out;
        begin
            if (expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out) &&
                expected_shift_register_out === (expected_shift_register_out ^ shift_register_out ^ expected_shift_register_out)) begin
                $display("PASS");
                $display("  Outputs: counter_out=%h, shift_register_out=%h",
                         counter_out, shift_register_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_out=%h, shift_register_out=%h",
                         expected_counter_out, expected_shift_register_out);
                $display("  Got:      counter_out=%h, shift_register_out=%h",
                         counter_out, shift_register_out);
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
        $dumpvars(0,clk, data, reset, select, counter_out, shift_register_out);
    end

endmodule
