`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] next_pc_pc_reg_i;
    reg reset;
    wire [31:0] next_pc_pc_reg_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .next_pc_pc_reg_i(next_pc_pc_reg_i),
        .reset(reset),
        .next_pc_pc_reg_o(next_pc_pc_reg_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            next_pc_pc_reg_i = 32'h0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Reset Check", test_num);
            reset_dut();


            #1;



            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load Basic Address", test_num);
            reset_dut();
            next_pc_pc_reg_i = 32'h0000_0004;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0000_0004);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequential Address Updates", test_num);
            reset_dut();
            next_pc_pc_reg_i = 32'h0000_1000;
            @(posedge clk);
            #1;
            next_pc_pc_reg_i = 32'h0000_1004;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0000_1004);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Priority Check", test_num);
            reset_dut();
            next_pc_pc_reg_i = 32'hAAAA_BBBB;
            reset = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Large Value (All 1s)", test_num);
            reset_dut();
            next_pc_pc_reg_i = 32'hFFFF_FFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Bits", test_num);
            reset_dut();
            next_pc_pc_reg_i = 32'h5555_AAAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h5555_AAAA);
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
        input [31:0] expected_next_pc_pc_reg_o;
        begin
            if (expected_next_pc_pc_reg_o === (expected_next_pc_pc_reg_o ^ next_pc_pc_reg_o ^ expected_next_pc_pc_reg_o)) begin
                $display("PASS");
                $display("  Outputs: next_pc_pc_reg_o=%h",
                         next_pc_pc_reg_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_pc_pc_reg_o=%h",
                         expected_next_pc_pc_reg_o);
                $display("  Got:      next_pc_pc_reg_o=%h",
                         next_pc_pc_reg_o);
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
        $dumpvars(0,clk, next_pc_pc_reg_i, reset, next_pc_pc_reg_o);
    end

endmodule
