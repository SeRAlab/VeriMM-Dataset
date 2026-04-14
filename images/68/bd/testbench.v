`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] bin_in;
    reg clk;
    wire [6:0] led_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin_in(bin_in),
        .clk(clk),
        .led_out(led_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        bin_in = 4'h0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        bin_in = 4'h0;
        @(posedge clk);
        #1;
        $display("Testcase %0d: Input 4'h0 (Expected: 0)", test_num);
        #1;

        check_outputs(7'h7E);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        bin_in = 4'h1;
        @(posedge clk);
        #1;
        $display("Testcase %0d: Input 4'h1 (Expected: 1)", test_num);
        #1;

        check_outputs(7'h30);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        bin_in = 4'h2;
        @(posedge clk);
        #1;
        $display("Testcase %0d: Input 4'h2 (Expected: 2)", test_num);
        #1;

        check_outputs(7'h6D);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        bin_in = 4'h3;
        @(posedge clk);
        #1;
        $display("Testcase %0d: Input 4'h3 (Expected: 3)", test_num);
        #1;

        check_outputs(7'h79);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        bin_in = 4'h4;
        @(posedge clk);
        #1;
        $display("Testcase %0d: Input 4'h4 (Expected: 4)", test_num);
        #1;

        check_outputs(7'h33);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        bin_in = 4'h5;
        @(posedge clk);
        #1;
        $display("Testcase %0d: Input 4'h5 (Expected: 5)", test_num);
        #1;

        check_outputs(7'h5B);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        bin_in = 4'h6;
        @(posedge clk);
        #1;
        $display("Testcase %0d: Input 4'h6 (Expected: 6)", test_num);
        #1;

        check_outputs(7'h5F);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        bin_in = 4'h7;
        @(posedge clk);
        #1;
        $display("Testcase %0d: Input 4'h7 (Expected: 7)", test_num);
        #1;

        check_outputs(7'h70);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        test_num = 9;
        bin_in = 4'h8;
        @(posedge clk);
        #1;
        $display("Testcase %0d: Input 4'h8 (Expected: 8)", test_num);
        #1;

        check_outputs(7'h7F);
    end
        endtask

    task testcase010;

    begin
        reset_dut();
        test_num = 10;
        bin_in = 4'h9;
        @(posedge clk);
        #1;
        $display("Testcase %0d: Input 4'h9 (Expected: 9)", test_num);
        #1;

        check_outputs(7'h7B);
    end
        endtask

    task testcase011;

    begin
        reset_dut();
        test_num = 11;
        bin_in = 4'hA;
        @(posedge clk);
        #1;
        $display("Testcase %0d: Input 4'hA (Expected: A)", test_num);
        #1;

        check_outputs(7'h77);
    end
        endtask

    task testcase012;

    begin
        reset_dut();
        test_num = 12;
        bin_in = 4'hB;
        @(posedge clk);
        #1;
        $display("Testcase %0d: Input 4'hB (Expected: b)", test_num);
        #1;

        check_outputs(7'h1F);
    end
        endtask

    task testcase013;

    begin
        reset_dut();
        test_num = 13;
        bin_in = 4'hC;
        @(posedge clk);
        #1;
        $display("Testcase %0d: Input 4'hC (Expected: C)", test_num);
        #1;

        check_outputs(7'h4E);
    end
        endtask

    task testcase014;

    begin
        reset_dut();
        test_num = 14;
        bin_in = 4'hD;
        @(posedge clk);
        #1;
        $display("Testcase %0d: Input 4'hD (Expected: d)", test_num);
        #1;

        check_outputs(7'h3D);
    end
        endtask

    task testcase015;

    begin
        reset_dut();
        test_num = 15;
        bin_in = 4'hE;
        @(posedge clk);
        #1;
        $display("Testcase %0d: Input 4'hE (Expected: E)", test_num);
        #1;

        check_outputs(7'h4F);
    end
        endtask

    task testcase016;

    begin
        reset_dut();
        test_num = 16;
        bin_in = 4'hF;
        @(posedge clk);
        #1;
        $display("Testcase %0d: Input 4'hF (Expected: F)", test_num);
        #1;

        check_outputs(7'h47);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [6:0] expected_led_out;
        begin
            if (expected_led_out === (expected_led_out ^ led_out ^ expected_led_out)) begin
                $display("PASS");
                $display("  Outputs: led_out=%h",
                         led_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led_out=%h",
                         expected_led_out);
                $display("  Got:      led_out=%h",
                         led_out);
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
        $dumpvars(0,bin_in, clk, led_out);
    end

endmodule
