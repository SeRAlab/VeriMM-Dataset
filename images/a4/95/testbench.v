`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] p0;
    reg [31:0] p1;
    reg reset;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .p0(p0),
        .p1(p1),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            p0 = 0;
            p1 = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic multiplication (5 * 4)", test_num);
            reset_dut();
            p0 = 32'd5;
            p1 = 32'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'd20);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication by zero", test_num);
            reset_dut();
            p0 = 32'h0;
            p1 = 32'h12345678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity multiplication", test_num);
            reset_dut();
            p0 = 32'h1;
            p1 = 32'hDEADBEEF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large product (No overflow)", test_num);
            reset_dut();
            p0 = 32'h0000FFFF;
            p1 = 32'h0000FFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFE0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max value overflow", test_num);
            reset_dut();
            p0 = 32'hFFFFFFFF;
            p1 = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power of 2 overflow", test_num);
            reset_dut();
            p0 = 32'h80000000;
            p1 = 32'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex value check", test_num);
            reset_dut();
            p0 = 32'h1234;
            p1 = 32'h5678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h06260060);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset persistence", test_num);
            p0 = 32'hFFFFFFFF;
            p1 = 32'hFFFFFFFF;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0);
            reset = 0;
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed-style unsigned multiplication", test_num);
            reset_dut();
            p0 = 32'hFFFFFFFE;
            p1 = 32'h2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFC);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit pattern multiplication", test_num);
            reset_dut();
            p0 = 32'hAAAA5555;
            p1 = 32'h2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h5554AAAA);
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
        input [31:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, p0, p1, reset, out);
    end

endmodule
