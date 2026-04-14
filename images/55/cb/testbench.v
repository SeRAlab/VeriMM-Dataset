`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rotary_A;
    reg rotary_B;
    reg rst;
    wire rotary_event;
    wire rotary_left;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rotary_A(rotary_A),
        .rotary_B(rotary_B),
        .rst(rst),
        .rotary_event(rotary_event),
        .rotary_left(rotary_left)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            rotary_A = 0;
            rotary_B = 0;
            #(15);
            rst = 0;
            #(10);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Check", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Rising Edge on A, B=0", test_num);
            reset_dut();

            @(posedge clk);
            rotary_A <= 0;
            rotary_B <= 0;

            @(posedge clk);
            rotary_A <= 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Rising Edge on A, B=1", test_num);
            reset_dut();

            @(posedge clk);
            rotary_A <= 0;
            rotary_B <= 1;

            @(posedge clk);
            rotary_A <= 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Falling Edge on A", test_num);
            reset_dut();


            @(posedge clk);
            rotary_A <= 1;
            @(posedge clk);

            @(posedge clk);
            rotary_A <= 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Stable Signal Check", test_num);
            reset_dut();

            @(posedge clk);
            rotary_A <= 1;
            @(posedge clk);

            @(posedge clk);
            rotary_A <= 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Rapid Toggle Check", test_num);
            reset_dut();


            @(posedge clk);
            rotary_A <= 1;
            rotary_B <= 1;


            @(posedge clk);
            rotary_A <= 0;


            @(posedge clk);
            rotary_A <= 1;
            rotary_B <= 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_rotary_event;
        input expected_rotary_left;
        begin
            if (expected_rotary_event === (expected_rotary_event ^ rotary_event ^ expected_rotary_event) &&
                expected_rotary_left === (expected_rotary_left ^ rotary_left ^ expected_rotary_left)) begin
                $display("PASS");
                $display("  Outputs: rotary_event=%b, rotary_left=%b",
                         rotary_event, rotary_left);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rotary_event=%b, rotary_left=%b",
                         expected_rotary_event, expected_rotary_left);
                $display("  Got:      rotary_event=%b, rotary_left=%b",
                         rotary_event, rotary_left);
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
        $dumpvars(0,clk, rotary_A, rotary_B, rst, rotary_event, rotary_left);
    end

endmodule
