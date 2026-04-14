`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [16:0] a;
    reg [16:0] b;
    reg clk;
    wire [33:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a <= 17'd0;
            b <= 17'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 0 * 0", test_num);
            a <= 17'sd0;
            b <= 17'sd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(34'sd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 1 * 123", test_num);
            a <= 17'sd1;
            b <= 17'sd123;
            @(posedge clk);
            #1;
            #1;

            check_outputs(34'sd123);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: -5 * 10", test_num);
            a <= -17'sd5;
            b <= 17'sd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-34'sd50);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: -12 * -12", test_num);
            a <= -17'sd12;
            b <= -17'sd12;
            @(posedge clk);
            #1;
            #1;

            check_outputs(34'sd144);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 1234 * 5678", test_num);
            a <= 17'sd1234;
            b <= 17'sd5678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(34'sd7006652);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Max Positive * Max Positive (65535 * 65535)", test_num);
            a <= 17'sd65535;
            b <= 17'sd65535;
            @(posedge clk);
            #1;
            #1;

            check_outputs(34'sd4294836225);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Min Negative * Min Negative (-65536 * -65536)", test_num);
            a <= -17'sd65536;
            b <= -17'sd65536;
            @(posedge clk);
            #1;
            #1;

            check_outputs(34'sd4294967296);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Min Negative * Max Positive (-65536 * 65535)", test_num);
            a <= -17'sd65536;
            b <= 17'sd65535;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-34'sd4294901760);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: -1 * 1000", test_num);
            a <= -17'sd1;
            b <= 17'sd1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-34'sd1000);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: 0 * -65536", test_num);
            a <= 17'sd0;
            b <= -17'sd65536;
            @(posedge clk);
            #1;
            #1;

            check_outputs(34'sd0);
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
        testcase009();
        testcase010();
        
        
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
        input [33:0] expected_p;
        begin
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
        $dumpvars(0,a, b, clk, p);
    end

endmodule
