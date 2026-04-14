`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] reg_out1;
    reg [31:0] reg_out2;
    reg rst_n;
    wire [31:0] reg_A;
    wire [31:0] reg_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reg_out1(reg_out1),
        .reg_out2(reg_out2),
        .rst_n(rst_n),
        .reg_A(reg_A),
        .reg_B(reg_B)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            reg_out1 = 32'h0;
            reg_out2 = 32'h0;
            @(posedge clk);
            #1;
            rst_n = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Reset to X", test_num);
            reset_dut();

            #1;


            check_outputs(32'hXXXXXXXX, 32'hXXXXXXXX);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Data Storage", test_num);
            reset_dut();
            reg_out1 = 32'h12345678;
            reg_out2 = 32'h87654321;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678, 32'h87654321);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All 1s and All 0s Patterns", test_num);
            reset_dut();
            reg_out1 = 32'hFFFFFFFF;
            reg_out2 = 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bit Patterns", test_num);
            reset_dut();
            reg_out1 = 32'hAAAAAAAA;
            reg_out2 = 32'h55555555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAAAAAA, 32'h55555555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Update and Stability", test_num);
            reset_dut();


            reg_out1 = 32'h11111111;
            reg_out2 = 32'h22222222;
            @(posedge clk);
            #1;


            reg_out1 = 32'hEEEEEEEE;
            reg_out2 = 32'hFFFFFFFF;
            #5;


            if (reg_A === 32'h11111111 && reg_B === 32'h22222222) begin

                @(posedge clk);
                #1;
                #1;

                check_outputs(32'hEEEEEEEE, 32'hFFFFFFFF);
            end else begin
                $display("FAIL: Output changed before clock edge");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Priority Over Data", test_num);
            reset_dut();


            reg_out1 = 32'hDEADBEEF;
            reg_out2 = 32'hCAFEBABE;
            rst_n = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hXXXXXXXX, 32'hXXXXXXXX);
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
        input [31:0] expected_reg_A;
        input [31:0] expected_reg_B;
        begin
            if (expected_reg_A === (expected_reg_A ^ reg_A ^ expected_reg_A) &&
                expected_reg_B === (expected_reg_B ^ reg_B ^ expected_reg_B)) begin
                $display("PASS");
                $display("  Outputs: reg_A=%h, reg_B=%h",
                         reg_A, reg_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reg_A=%h, reg_B=%h",
                         expected_reg_A, expected_reg_B);
                $display("  Got:      reg_A=%h, reg_B=%h",
                         reg_A, reg_B);
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
        $dumpvars(0,clk, reg_out1, reg_out2, rst_n, reg_A, reg_B);
    end

endmodule
