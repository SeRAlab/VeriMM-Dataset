`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] imm;
    reg [15:0] mem;
    reg [1:0] opsource;
    reg [15:0] rg;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .imm(imm),
        .mem(mem),
        .opsource(opsource),
        .rg(rg),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select rg (opsource=00)", test_num);
            rg = 16'h1234;
            mem = 16'h5678;
            imm = 16'h9ABC;
            opsource = 2'b00;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select mem (opsource=01)", test_num);
            rg = 16'hAAAA;
            mem = 16'hBBBB;
            imm = 16'hCCCC;
            opsource = 2'b01;
            #1;

            check_outputs(16'hBBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select imm (opsource=10)", test_num);
            rg = 16'hF0F0;
            mem = 16'h0F0F;
            imm = 16'hFFFF;
            opsource = 2'b10;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select default (opsource=11)", test_num);
            rg = 16'h1111;
            mem = 16'h2222;
            imm = 16'h3333;
            opsource = 2'b11;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary check - All zeros", test_num);
            rg = 16'h0000;
            mem = 16'h0000;
            imm = 16'h0000;
            opsource = 2'b00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Switching select bits rapidly", test_num);
            rg = 16'hC0DE;
            mem = 16'hBEEF;
            imm = 16'hFEED;

            opsource = 2'b01;
            #5;
            opsource = 2'b10;
            #1;

            check_outputs(16'hFEED);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: rg with bit patterns", test_num);
            rg = 16'h5555;
            mem = 16'h0000;
            imm = 16'h0000;
            opsource = 2'b00;
            #1;

            check_outputs(16'h5555);
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
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

endmodule
