`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg v6dda25;
    reg vccca56;
    reg [7:0] vec26ff;
    wire [7:0] v19a59f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .v6dda25(v6dda25),
        .vccca56(vccca56),
        .vec26ff(vec26ff),
        .v19a59f(v19a59f)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs zero", test_num);
        v6dda25 = 1'b0;
        vccca56 = 1'b0;
        vec26ff = 8'h00;
        #10;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: v6dda25 Low, vccca56 Low, vec26ff Max", test_num);
        v6dda25 = 1'b0;
        vccca56 = 1'b0;
        vec26ff = 8'hFF;
        #10;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Voltage control vccca56 High, Alternating bits", test_num);
        v6dda25 = 1'b0;
        vccca56 = 1'b1;
        vec26ff = 8'h55;
        #10;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Control v6dda25 High, Alternating bits", test_num);
        v6dda25 = 1'b1;
        vccca56 = 1'b0;
        vec26ff = 8'hAA;
        #10;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Both controls High, Lower nibble", test_num);
        v6dda25 = 1'b1;
        vccca56 = 1'b1;
        vec26ff = 8'h0F;
        #10;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Both controls High, Upper nibble", test_num);
        v6dda25 = 1'b1;
        vccca56 = 1'b1;
        vec26ff = 8'hF0;
        #10;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Walking one bit 0", test_num);
        v6dda25 = 1'b0;
        vccca56 = 1'b1;
        vec26ff = 8'h01;
        #10;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Walking one bit 7", test_num);
        v6dda25 = 1'b1;
        vccca56 = 1'b0;
        vec26ff = 8'h80;
        #10;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mid-range value", test_num);
        v6dda25 = 1'b1;
        vccca56 = 1'b1;
        vec26ff = 8'h7E;
        #10;
        #1;

        check_outputs(8'h7E);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Full Toggle stimulus", test_num);
        v6dda25 = 1'b1;
        vccca56 = 1'b1;
        vec26ff = 8'hFF;
        #10;
        #1;

        check_outputs(8'hFF);
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
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_v19a59f;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_v19a59f === (expected_v19a59f ^ v19a59f ^ expected_v19a59f)) begin
                $display("PASS");
                $display("  Outputs: v19a59f=%h",
                         v19a59f);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: v19a59f=%h",
                         expected_v19a59f);
                $display("  Got:      v19a59f=%h",
                         v19a59f);
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
