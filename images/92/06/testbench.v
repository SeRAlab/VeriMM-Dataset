`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] digit;
    reg rst_n;
    wire [18:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .digit(digit),
        .rst_n(rst_n),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            digit = 16'h0000;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 16'h0000", test_num);
            reset_dut();
            digit = 16'h0000;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(19'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 16'hFFFF", test_num);
            reset_dut();
            digit = 16'hFFFF;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(19'h7FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 16'h1234", test_num);
            reset_dut();
            digit = 16'h1234;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(19'h12345);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 16'hABCD", test_num);
            reset_dut();
            digit = 16'hABCD;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(19'h5BCDE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 16'hAAAA", test_num);
            reset_dut();
            digit = 16'hAAAA;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(19'h2AAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 16'h5555", test_num);
            reset_dut();
            digit = 16'h5555;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(19'h15555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 16'hBEEF", test_num);
            reset_dut();
            digit = 16'hBEEF;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(19'h3BEEF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 16'hC0DE", test_num);
            reset_dut();
            digit = 16'hC0DE;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(19'h4C0DE);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input 16'h8421", test_num);
            reset_dut();
            digit = 16'h8421;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(19'h08421);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Reset state", test_num);

            digit = 16'hFFFF;
            #10;

            rst_n = 0;
            #20;

            #1;


            check_outputs(19'h00000);
            rst_n = 1;
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
        input [18:0] expected_out;
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
        $dumpvars(0,clk, digit, rst_n, out);
    end

endmodule
