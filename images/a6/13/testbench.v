`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] float_in;
    reg rst_n;
    wire [31:0] int_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .float_in(float_in),
        .rst_n(rst_n),
        .int_out(int_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            float_in = 32'h0;
            @(posedge clk);
            #2;
            rst_n = 1;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            rst_n = 0;
            float_in = 32'h41200000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Reset behavior with input 10.0", test_num);
            #1;

            check_outputs(32'h00000000);
            rst_n = 1;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            float_in = 32'h00000000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Input 0.0", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            float_in = 32'h80000000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Input -0.0", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            float_in = 32'h3F800000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Input 1.0", test_num);
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            float_in = 32'hBF800000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Input -1.0", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            float_in = 32'h41280000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Input 10.5 (Truncate to 10)", test_num);
            #1;

            check_outputs(32'h0000000A);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            float_in = 32'hC1280000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Input -10.5 (Truncate to -10)", test_num);
            #1;

            check_outputs(32'hFFFFFFF6);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            float_in = 32'h3F400000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Input 0.75 (Truncate to 0)", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            float_in = 32'hBF400000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Input -0.75 (Truncate to 0)", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            float_in = 32'h46000000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Input 8192.0", test_num);
            #1;

            check_outputs(32'h00002000);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            reset_dut();
            float_in = 32'h4E800000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Input 2^30", test_num);
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            reset_dut();
            float_in = 32'hCF000000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Input -2^31 (Boundary)", test_num);
            #1;

            check_outputs(32'h80000000);
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
        input [31:0] expected_int_out;
        begin
            if (expected_int_out === (expected_int_out ^ int_out ^ expected_int_out)) begin
                $display("PASS");
                $display("  Outputs: int_out=%h",
                         int_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: int_out=%h",
                         expected_int_out);
                $display("  Got:      int_out=%h",
                         int_out);
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
        $dumpvars(0,clk, float_in, rst_n, int_out);
    end

endmodule
