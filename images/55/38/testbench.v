`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] baud_freq;
    reg [15:0] baud_limit;
    reg clock;
    reg reset;
    wire ce_16;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .baud_freq(baud_freq),
        .baud_limit(baud_limit),
        .clock(clock),
        .reset(reset),
        .ce_16(ce_16)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            baud_freq = 0;
            baud_limit = 0;
            repeat(2) @(posedge clock);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Freq equals Limit - Expect ce_16=1 after 1 cycle", test_num);
            reset_dut();
            baud_freq = 12'd10;
            baud_limit = 16'd10;
            @(posedge clock);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Freq less than Limit - Expect ce_16=0 after 1 cycle", test_num);
            reset_dut();
            baud_freq = 12'd5;
            baud_limit = 16'd10;
            @(posedge clock);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Freq reaches Limit after 2 cycles - Expect ce_16=1", test_num);
            reset_dut();
            baud_freq = 12'd5;
            baud_limit = 16'd10;
            repeat(2) @(posedge clock);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Slow count - Expect ce_16=0 at cycle 19", test_num);
            reset_dut();
            baud_freq = 12'd1;
            baud_limit = 16'd20;
            repeat(19) @(posedge clock);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Slow count - Expect ce_16=1 at cycle 20", test_num);
            reset_dut();
            baud_freq = 12'd1;
            baud_limit = 16'd20;
            repeat(20) @(posedge clock);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Freq > Limit - Expect ce_16=1 immediately", test_num);
            reset_dut();
            baud_freq = 12'd50;
            baud_limit = 16'd10;
            @(posedge clock);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Freq=0 - Expect ce_16=0 after 10 cycles", test_num);
            reset_dut();
            baud_freq = 12'd0;
            baud_limit = 16'd10;
            repeat(10) @(posedge clock);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pulse check - Expect ce_16=0 the cycle after a tick", test_num);
            reset_dut();
            baud_freq = 12'd1;
            baud_limit = 16'd2;
            repeat(3) @(posedge clock);
            #1 #1;
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
        input expected_ce_16;
        begin
            if (expected_ce_16 === (expected_ce_16 ^ ce_16 ^ expected_ce_16)) begin
                $display("PASS");
                $display("  Outputs: ce_16=%b",
                         ce_16);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ce_16=%b",
                         expected_ce_16);
                $display("  Got:      ce_16=%b",
                         ce_16);
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
        $dumpvars(0,baud_freq, baud_limit, clock, reset, ce_16);
    end

endmodule
