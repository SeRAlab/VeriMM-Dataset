`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] als;
    reg [11:0] dll;
    reg en;
    wire [7:0] dim;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .als(als),
        .dll(dll),
        .en(en),
        .dim(dim)
    );
    task testcase001;

    begin
        test_num = 1;
        als = 12'hFFF;
        dll = 12'h000;
        en = 1'b0;
        $display("Test Case %0d: Enable low", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        als = 12'h500;
        dll = 12'h500;
        en = 1'b1;
        $display("Test Case %0d: als == dll", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        als = 12'h100;
        dll = 12'h500;
        en = 1'b1;
        $display("Test Case %0d: als < dll", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        als = 12'd1000;
        dll = 12'd500;
        en = 1'b1;
        $display("Test Case %0d: Standard diff (1000-500) >> 4", test_num);
        #1;

        check_outputs(8'h1F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        als = 12'hFFF;
        dll = 12'h000;
        en = 1'b1;
        $display("Test Case %0d: Max diff (4095-0) >> 4", test_num);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        als = 12'd16;
        dll = 12'd0;
        en = 1'b1;
        $display("Test Case %0d: Small diff (16-0) >> 4", test_num);
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        als = 12'd15;
        dll = 12'd0;
        en = 1'b1;
        $display("Test Case %0d: Diff < 16 (15-0) >> 4", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        als = 12'd4000;
        dll = 12'd100;
        en = 1'b1;

        $display("Test Case %0d: High range calculation", test_num);
        #1;

        check_outputs(8'hF3);
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
        input [7:0] expected_dim;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dim === (expected_dim ^ dim ^ expected_dim)) begin
                $display("PASS");
                $display("  Outputs: dim=%h",
                         dim);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dim=%h",
                         expected_dim);
                $display("  Got:      dim=%h",
                         dim);
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
