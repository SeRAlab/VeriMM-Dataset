`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg clk;
    reg reset;
    wire [31:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            a = 0;
            b = 0;
            @(posedge clk);
            #1;
            reset = 0;

            repeat(20) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 5 * 10", test_num);
            reset = 1;
            a = 16'd5;
            b = 16'd10;
            @(posedge clk);
            #1 reset = 0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(32'sd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 7 * -3", test_num);
            reset = 1;
            a = 16'sd7;
            b = -16'sd3;
            @(posedge clk);
            #1 reset = 0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(-32'sd21);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: -12 * 4", test_num);
            reset = 1;
            a = -16'sd12;
            b = 16'sd4;
            @(posedge clk);
            #1 reset = 0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(-32'sd48);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: -6 * -8", test_num);
            reset = 1;
            a = -16'sd6;
            b = -16'sd8;
            @(posedge clk);
            #1 reset = 0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(32'sd48);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 0 * 1234", test_num);
            reset = 1;
            a = 16'sd0;
            b = 16'sd1234;
            @(posedge clk);
            #1 reset = 0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(32'sd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 32767 * 2", test_num);
            reset = 1;
            a = 16'sd32767;
            b = 16'sd2;
            @(posedge clk);
            #1 reset = 0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(32'sd65534);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: -32768 * 5", test_num);
            reset = 1;
            a = -16'sd32768;
            b = 16'sd5;
            @(posedge clk);
            #1 reset = 0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(-32'sd163840);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: -1 * -1", test_num);
            reset = 1;
            a = -16'sd1;
            b = -16'sd1;
            @(posedge clk);
            #1 reset = 0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(32'sd1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 1000 * 1000", test_num);
            reset = 1;
            a = 16'sd1000;
            b = 16'sd1000;
            @(posedge clk);
            #1 reset = 0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(32'sd1000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: -32768 * -1", test_num);
            reset = 1;
            a = -16'sd32768;
            b = -16'sd1;
            @(posedge clk);
            #1 reset = 0;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(32'sd32768);
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
        input [31:0] expected_p;
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
        $dumpvars(0,a, b, clk, reset, p);
    end

endmodule
