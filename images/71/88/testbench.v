`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] fp_in;
    wire [31:0] int_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fp_in(fp_in),
        .int_out(int_out)
    );
    task testcase001;

    begin
        test_num = 1;
        fp_in = 32'h00000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        fp_in = 32'h3f800000;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        fp_in = 32'hbf800000;
        #1;

        check_outputs(32'hffffffff);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        fp_in = 32'h41200000;
        #1;

        check_outputs(32'h0000000a);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        fp_in = 32'hc1200000;
        #1;

        check_outputs(32'hfffffff6);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        fp_in = 32'h3f000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        fp_in = 32'h417a0000;
        #1;

        check_outputs(32'h0000000f);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        fp_in = 32'h44800000;
        #1;

        check_outputs(32'h00000400);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        fp_in = 32'hc5000000;
        #1;

        check_outputs(32'hfffff800);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        fp_in = 32'hbf400000;
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
        input [31:0] expected_int_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_int_out === (expected_int_out ^ int_out ^ expected_int_out)) begin
                $display("PASS");
                $display("  Outputs: int_out=%h",
                         int_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: int_out=%h",
                         expected_int_out);
                $display("  Got:      int_out=%h",
                         int_out);
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
