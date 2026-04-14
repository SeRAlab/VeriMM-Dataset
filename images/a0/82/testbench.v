`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [7:0] e;
    reg vgae2;
    wire [3:0] num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .e(e),
        .vgae2(vgae2),
        .num(num)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable high, input within range (0)", test_num);
        vgae2 = 1;
        e = 8'h00;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable high, input within range (5)", test_num);
        vgae2 = 1;
        e = 8'h05;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable high, input at boundary (9)", test_num);
        vgae2 = 1;
        e = 8'h09;
        #1;

        check_outputs(4'd9);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable high, input out of range (10)", test_num);
        vgae2 = 1;
        e = 8'h0A;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable high, input out of range (15)", test_num);
        vgae2 = 1;
        e = 8'h0F;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable high, ignore upper 4 bits of input (e=0xF2)", test_num);
        vgae2 = 1;
        e = 8'hF2;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable high, ignore upper 4 bits, out of range lower bits (e=0xAE)", test_num);
        vgae2 = 1;
        e = 8'hAE;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable high, random value 7", test_num);
        vgae2 = 1;
        e = 8'h07;
        #1;

        check_outputs(4'd7);
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
        input [3:0] expected_num;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_num === (expected_num ^ num ^ expected_num)) begin
                $display("PASS");
                $display("  Outputs: num=%h",
                         num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: num=%h",
                         expected_num);
                $display("  Got:      num=%h",
                         num);
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
