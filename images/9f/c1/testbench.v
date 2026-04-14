`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [31:0] pc_i;
    reg rst_i;
    reg start_i;
    wire [31:0] pc_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .pc_i(pc_i),
        .rst_i(rst_i),
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
            rst_i = 0;
            start_i = 0;
            pc_i = 32'h0;
            @(posedge clk_i);
            #1;
            rst_i = 1;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying reset state", test_num);
            reset_dut();
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load value 0xABCDE001", test_num);
            reset_dut();
            pc_i = 32'hABCDE001;
            start_i = 1;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(32'hABCDE001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold value when start_i is low", test_num);
            reset_dut();


            pc_i = 32'h12345678;
            start_i = 1;
            @(posedge clk_i);
            #1;


            start_i = 0;
            pc_i = 32'hFFFFFFFF;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Consecutive loads", test_num);
            reset_dut();

            start_i = 1;
            pc_i = 32'h00000010;
            @(posedge clk_i);
            #1;

            pc_i = 32'h00000020;
            @(posedge clk_i);
            #1;

            pc_i = 32'h00000030;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(32'h00000030);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset while start_i is active", test_num);
            reset_dut();


            pc_i = 32'h5555AAAA;
            start_i = 1;
            @(posedge clk_i);
            #1;


            rst_i = 0;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load max 32-bit value", test_num);
            reset_dut();

            pc_i = 32'hFFFFFFFF;
            start_i = 1;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
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
        $dumpvars(0,clk_i, pc_i, rst_i, start_i, pc_o);
    end

endmodule
