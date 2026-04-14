`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] d;
    reg en;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .d(d),
        .en(en),
        .q(q)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Enable low (Disabled) - Output should be 0", test_num);
        d = 32'hFFFF_FFFF;
        en = 0;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Enable high (Enabled) - Output should match input", test_num);
        d = 32'h1234_5678;
        en = 1;
        #1;

        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Enable high (Enabled) - Input all ones", test_num);
        d = 32'hFFFF_FFFF;
        en = 1;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Enable low (Disabled) - Random data should be zeroed", test_num);
        d = 32'hA5A5_5A5A;
        en = 0;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Enable high (Enabled) - Input all zeros", test_num);
        d = 32'h0000_0000;
        en = 1;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Alternating bit pattern while enabled", test_num);
        d = 32'hAAAA_AAAA;
        en = 1;
        #1;

        check_outputs(32'hAAAA_AAAA);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Alternating bit pattern while disabled", test_num);
        d = 32'h5555_5555;
        en = 0;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: Large hex value while enabled", test_num);
        d = 32'hDEAD_BEEF;
        en = 1;
        #1;

        check_outputs(32'hDEAD_BEEF);
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
        input [31:0] expected_q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
