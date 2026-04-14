`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CSRSel;
    reg clk;
    reg reset;
    reg [31:0] rs1_to_csr;
    wire [31:0] csr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CSRSel(CSRSel),
        .clk(clk),
        .reset(reset),
        .rs1_to_csr(rs1_to_csr),
        .csr(csr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            CSRSel = 0;
            rs1_to_csr = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();
            @(posedge clk);
            #1 #1;
 check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Load value when CSRSel=1", test_num);
            reset_dut();
            CSRSel = 1;
            rs1_to_csr = 32'hDEADBEEF;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Data hold when CSRSel=0", test_num);
            reset_dut();

            CSRSel = 1;
            rs1_to_csr = 32'h12345678;
            @(posedge clk);

            #1 CSRSel = 0;
            rs1_to_csr = 32'hFFFFFFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Reset priority over CSRSel", test_num);
            reset_dut();

            CSRSel = 1;
            rs1_to_csr = 32'hAAAAAAAA;
            @(posedge clk);

            #1 reset = 1;
            CSRSel = 1;
            rs1_to_csr = 32'h55555555;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Load max value 0xFFFFFFFF", test_num);
            reset_dut();
            CSRSel = 1;
            rs1_to_csr = 32'hFFFFFFFF;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Sequential updates", test_num);
            reset_dut();
            CSRSel = 1;
            rs1_to_csr = 32'h00001111;
            @(posedge clk);
            #1 rs1_to_csr = 32'h22220000;
            @(posedge clk);
            #1 rs1_to_csr = 32'hABCDE000;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hABCDE000);
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
        input [31:0] expected_csr;
        begin
            if (expected_csr === (expected_csr ^ csr ^ expected_csr)) begin
                $display("PASS");
                $display("  Outputs: csr=%h",
                         csr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: csr=%h",
                         expected_csr);
                $display("  Got:      csr=%h",
                         csr);
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
        $dumpvars(0,CSRSel, clk, reset, rs1_to_csr, csr);
    end

endmodule
