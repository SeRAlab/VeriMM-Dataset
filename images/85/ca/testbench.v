`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg size;
    reg [31:0] unext;
    wire [31:0] ext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .en(en),
        .size(size),
        .unext(unext),
        .ext(ext)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Pass-through mode (en=0)", test_num);
            en = 0;
            size = 0;
            unext = 32'hABCDEF12;
            #1;

            check_outputs(32'hABCDEF12);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Byte extension (Positive)", test_num);
            en = 1;
            size = 0;
            unext = 32'hFFFF_FF7F;
            #1;

            check_outputs(32'h0000_007F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Byte extension (Negative)", test_num);
            en = 1;
            size = 0;
            unext = 32'h0000_0080;
            #1;

            check_outputs(32'hFFFF_FF80);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Half-word extension (Positive)", test_num);
            en = 1;
            size = 1;
            unext = 32'hABCD_7FFF;
            #1;

            check_outputs(32'h0000_7FFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Half-word extension (Negative)", test_num);
            en = 1;
            size = 1;
            unext = 32'h0000_8001;
            #1;

            check_outputs(32'hFFFF_8001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Byte extension (All ones)", test_num);
            en = 1;
            size = 0;
            unext = 32'h0000_00FF;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Half extension (All zeros)", test_num);
            en = 1;
            size = 1;
            unext = 32'hFFFF_0000;
            #1;

            check_outputs(32'h0000_0000);
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
        input [31:0] expected_ext;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ext === (expected_ext ^ ext ^ expected_ext)) begin
                $display("PASS");
                $display("  Outputs: ext=%h",
                         ext);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ext=%h",
                         expected_ext);
                $display("  Got:      ext=%h",
                         ext);
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
