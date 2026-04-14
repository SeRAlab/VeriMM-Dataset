`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] x;
    reg [31:0] y;
    wire [31:0] zhigh;
    wire [31:0] zlow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .zhigh(zhigh),
        .zlow(zlow)
    );
    task testcase001;

        begin
            test_num = 1;
            x = 32'h00000000;
            y = 32'h00000000;
            $display("Test %0d: All zeros input (x=0)", test_num);
            #1;

            check_outputs(32'h00000000, 32'hFFFFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            x = 32'hFFFFFFFF;
            y = 32'hFFFFFFFF;
            $display("Test %0d: All ones input (x=F...F)", test_num);
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            x = 32'hAAAAAAAA;
            y = 32'h55555555;
            $display("Test %0d: Alternating bits (x=A...A)", test_num);
            #1;

            check_outputs(32'h00000000, 32'h55555555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            x = 32'h55555555;
            y = 32'hAAAAAAAA;
            $display("Test %0d: Alternating bits (x=5...5)", test_num);
            #1;

            check_outputs(32'h00000000, 32'hAAAAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            x = 32'h12345678;
            y = 32'h9ABCDEF0;
            $display("Test %0d: Random pattern", test_num);
            #1;

            check_outputs(32'h00000000, 32'hEDCBA987);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            x = 32'hF0F0F0F0;
            y = 32'h0F0F0F0F;
            $display("Test %0d: Byte-wise alternating", test_num);
            #1;

            check_outputs(32'h00000000, 32'h0F0F0F0F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            x = 32'hDEADBEEF;
            y = 32'hCAFEBABE;
            $display("Test %0d: Hex literal check", test_num);
            #1;

            check_outputs(32'h00000000, 32'h21524110);
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
        input [31:0] expected_zhigh;
        input [31:0] expected_zlow;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_zhigh === (expected_zhigh ^ zhigh ^ expected_zhigh) &&
                expected_zlow === (expected_zlow ^ zlow ^ expected_zlow)) begin
                $display("PASS");
                $display("  Outputs: zhigh=%h, zlow=%h",
                         zhigh, zlow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: zhigh=%h, zlow=%h",
                         expected_zhigh, expected_zlow);
                $display("  Got:      zhigh=%h, zlow=%h",
                         zhigh, zlow);
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
