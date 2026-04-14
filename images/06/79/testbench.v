`timescale 1ns/1ps

module timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [31:0] timer_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    timer dut (
        .clk(clk),
        .reset(reset),
        .timer_value(timer_value)
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
            @(posedge clk);
            reset = 0;

            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Counting (5 cycles)", test_num);
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-count Reset", test_num);
            reset_dut();
            repeat(10) @(posedge clk);


            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;

            #1;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Long Count (100 cycles)", test_num);
            reset_dut();
            repeat(100) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check Zero After Reset", test_num);
            reset_dut();

            #1;


            check_outputs(32'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Higher Value Count (256 cycles)", test_num);
            reset_dut();
            repeat(256) @(posedge clk);
            #1;
            #1;

            check_outputs(32'd256);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("timer Testbench");
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
        input [31:0] expected_timer_value;
        begin
            if (expected_timer_value === (expected_timer_value ^ timer_value ^ expected_timer_value)) begin
                $display("PASS");
                $display("  Outputs: timer_value=%h",
                         timer_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: timer_value=%h",
                         expected_timer_value);
                $display("  Got:      timer_value=%h",
                         timer_value);
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
        $dumpvars(0,clk, reset, timer_value);
    end

endmodule
