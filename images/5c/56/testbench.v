`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] d;
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
        $display("Testcase %0d: Enable high, d at maximum value", test_num);
        d = 5'b11111;
        en = 1'b1;
        #1;

        check_outputs(32'h0000001F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Enable low, d at maximum value (output should be 0)", test_num);
        d = 5'b11111;
        en = 1'b0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Enable high, d at zero", test_num);
        d = 5'b00000;
        en = 1'b1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Enable high, d at alternating bit pattern", test_num);
        d = 5'b10101;
        en = 1'b1;
        #1;

        check_outputs(32'h00000015);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Enable low, d at alternating bit pattern (output should be 0)", test_num);
        d = 5'b10101;
        en = 1'b0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Enable high, d at value 5'h0A", test_num);
        d = 5'h0A;
        en = 1'b1;
        #1;

        check_outputs(32'h0000000A);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Transition en from 1 to 0 with d active", test_num);
        d = 5'h12;
        en = 1'b1;
        #5;
        en = 1'b0;
        #1;

        check_outputs(32'h00000000);
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
