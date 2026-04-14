`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg PCWrite_i;
    reg clk_i;
    reg [31:0] pc_i;
    reg start_i;
    wire [31:0] pc_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PCWrite_i(PCWrite_i),
        .clk_i(clk_i),
        .pc_i(pc_i),
        .start_i(start_i),
        .pc_o(pc_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            start_i = 0;
            PCWrite_i = 0;
            pc_i = 32'h0;
            @(negedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Reset check", test_num);
            reset_dut();
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Load value (PCWrite_i=0)", test_num);
            reset_dut();
            start_i = 1;
            PCWrite_i = 0;
            pc_i = 32'hA5A5A5A5;
            @(negedge clk_i);
            #1;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Hold value (PCWrite_i=1)", test_num);
            reset_dut();

            start_i = 1;
            PCWrite_i = 0;
            pc_i = 32'h12345678;
            @(negedge clk_i);
            #1;

            PCWrite_i = 1;
            pc_i = 32'hFFFFFFFF;
            @(negedge clk_i);
            #1;

            #1;


            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Sequential load flow", test_num);
            reset_dut();
            start_i = 1;
            PCWrite_i = 0;

            pc_i = 32'h4;
            @(negedge clk_i);
            #1;

            pc_i = 32'h8;
            @(negedge clk_i);
            #1;

            pc_i = 32'hC;
            @(negedge clk_i);
            #1;

            #1;


            check_outputs(32'h0000000C);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Reset mid-operation", test_num);
            reset_dut();
            start_i = 1;
            PCWrite_i = 0;
            pc_i = 32'hDEADBEEF;
            @(negedge clk_i);
            #1;


            start_i = 0;
            @(negedge clk_i);
            #1;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %03d: Load after Hold", test_num);
            reset_dut();
            start_i = 1;


            PCWrite_i = 1;
            pc_i = 32'h77777777;
            @(negedge clk_i);
            #1;


            PCWrite_i = 0;
            pc_i = 32'hBBBBBBBB;
            @(negedge clk_i);
            #1;

            #1;


            check_outputs(32'hBBBBBBBB);
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
        input [31:0] expected_pc_o;
        begin
            if (expected_pc_o === (expected_pc_o ^ pc_o ^ expected_pc_o)) begin
                $display("PASS");
                $display("  Outputs: pc_o=%h",
                         pc_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc_o=%h",
                         expected_pc_o);
                $display("  Got:      pc_o=%h",
                         pc_o);
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
        $dumpvars(0,PCWrite_i, clk_i, pc_i, start_i, pc_o);
    end

endmodule
