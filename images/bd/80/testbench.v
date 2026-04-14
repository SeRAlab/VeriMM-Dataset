`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg alu_src;
    reg [31:0] im_gen;
    reg [31:0] rdb;
    reg reset;
    wire [31:0] rdx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_src(alu_src),
        .im_gen(im_gen),
        .rdb(rdb),
        .reset(reset),
        .rdx(rdx)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: reset=1, alu_src=1 (Select im_gen)", test_num);
            reset = 1;
            alu_src = 1;
            im_gen = 32'h12345678;
            rdb = 32'h87654321;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: reset=1, alu_src=0 (Select rdb)", test_num);
            reset = 1;
            alu_src = 0;
            im_gen = 32'h12345678;
            rdb = 32'h87654321;
            #1;

            check_outputs(32'h87654321);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary - All Ones im_gen, All Zeros rdb (Select im_gen)", test_num);
            reset = 1;
            alu_src = 1;
            im_gen = 32'hFFFFFFFF;
            rdb = 32'h00000000;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary - All Ones im_gen, All Zeros rdb (Select rdb)", test_num);
            reset = 1;
            alu_src = 0;
            im_gen = 32'hFFFFFFFF;
            rdb = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bit patterns", test_num);
            reset = 1;
            alu_src = 1;
            im_gen = 32'hAAAAAAAA;
            rdb = 32'h55555555;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bit patterns (Select rdb)", test_num);
            reset = 1;
            alu_src = 0;
            im_gen = 32'hAAAAAAAA;
            rdb = 32'h55555555;
            #1;

            check_outputs(32'h55555555);
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
        input [31:0] expected_rdx;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rdx === (expected_rdx ^ rdx ^ expected_rdx)) begin
                $display("PASS");
                $display("  Outputs: rdx=%h",
                         rdx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdx=%h",
                         expected_rdx);
                $display("  Got:      rdx=%h",
                         rdx);
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

endmodule
