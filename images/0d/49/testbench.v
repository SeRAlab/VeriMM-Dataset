`timescale 1ns/1ps

module timer_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire [15:0] timer_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    timer_16bit dut (
        .clk(clk),
        .enable(enable),
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
            reset = 1;
            enable = 0;
            #10;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Increment", test_num);
            reset_dut();
            enable = 1;

            repeat (10) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable/Disable Functionality", test_num);
            reset_dut();
            enable = 1;
            repeat (5) @(posedge clk);
            #1 enable = 0;
            repeat (5) @(posedge clk);
            #1;

            #1;


            check_outputs(16'd5);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rollover (Max to 0)", test_num);
            reset_dut();
            enable = 1;

            repeat (65535) @(posedge clk);
            #1;
            if (timer_value !== 16'hFFFF) $display("Error: Did not reach Max before rollover");

            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Async Reset During Counting", test_num);
            reset_dut();
            enable = 1;
            repeat (100) @(posedge clk);
            #5 reset = 1;
            #1;
            #1;

            check_outputs(16'h0000);
            #5 reset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Resume After Disable", test_num);
            reset_dut();
            enable = 1;
            repeat (20) @(posedge clk);
            #1 enable = 0;
            repeat (10) @(posedge clk);
            #1 enable = 1;
            repeat (10) @(posedge clk);
            #1;

            #1;


            check_outputs(16'd30);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("timer_16bit Testbench");
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
        input [15:0] expected_timer_value;
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
        $dumpvars(0,clk, enable, reset, timer_value);
    end

endmodule
