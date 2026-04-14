`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] d;
    reg rst;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            d = 32'h0;
            #10;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Asynchronous Reset Load", test_num);
            d = 32'hA5A5A5A5;
            rst = 1;
            #2;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Clear on negative clock edge", test_num);

            d = 32'hFFFFFFFF;
            rst = 1;
            #5;
            rst = 0;

            @(negedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Asynchronous update while reset is high", test_num);
            rst = 1;
            d = 32'h11111111;
            #5;
            d = 32'h22222222;
            #5;
            #1;

            check_outputs(32'h22222222);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Reset priority over negative clock edge", test_num);
            d = 32'hBEEFBEEF;
            rst = 1;
            @(negedge clk);
            #2;
            #1;

            check_outputs(32'hBEEFBEEF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Value stability on positive clock edge", test_num);

            d = 32'h12345678;
            rst = 1;
            #5;
            rst = 0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: D change ignore when rst is low and no negedge", test_num);

            d = 32'hCAFED00D;
            rst = 1;
            #5;
            rst = 0;
            #2;

            force clk = 1;
            d = 32'hDEADBEEF;
            #5;
            #1;

            check_outputs(32'hCAFED00D);
            release clk;
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
        input [31:0] expected_q;
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
        $dumpvars(0,clk, d, rst, q);
    end

endmodule
