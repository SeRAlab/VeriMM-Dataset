`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clr;
    wire [4:0] h;
    wire [5:0] m;
    wire [5:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clr(clr),
        .h(h),
        .m(m),
        .s(s)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            @(posedge clk);
            #1 clr = 0;


        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: 10-Second Count Check", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(0, 0, 10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: 1-Minute Transition (60s)", test_num);
            reset_dut();
            repeat(60) @(posedge clk);
            #1 #1;
 check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: 1-Hour Transition (3600s)", test_num);
            reset_dut();
            repeat(3600) @(posedge clk);
            #1 #1;
 check_outputs(1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: 24-Hour Rollover Check", test_num);
            reset_dut();

            repeat(86399) @(posedge clk);
            #1 $display("  At 23:59:59...");
            #1;

            check_outputs(23, 59, 59);


            @(posedge clk);
            #1 $display("  At 00:00:00 (Rollover)...");
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Mid-operation Clear", test_num);
            reset_dut();
            repeat(123) @(posedge clk);
            #1 $display("  Current time: h=%h, m=%h, s=%h", h, m, s);

            clr = 1;
            @(posedge clk);
            #1 clr = 0;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: 59 min 59 sec to 1 hour", test_num);
            reset_dut();

            repeat(3599) @(posedge clk);
            #1 #1;
 check_outputs(0, 59, 59);

            @(posedge clk);
            #1 #1;
 check_outputs(1, 0, 0);
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
        input [4:0] expected_h;
        input [5:0] expected_m;
        input [5:0] expected_s;
        begin
            if (expected_h === (expected_h ^ h ^ expected_h) &&
                expected_m === (expected_m ^ m ^ expected_m) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: h=%h, m=%h, s=%h",
                         h, m, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h=%h, m=%h, s=%h",
                         expected_h, expected_m, expected_s);
                $display("  Got:      h=%h, m=%h, s=%h",
                         h, m, s);
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
        $dumpvars(0,clk, clr, h, m, s);
    end

endmodule
