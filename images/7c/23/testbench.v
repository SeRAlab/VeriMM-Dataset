`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] addr_i;
    wire pre_dec_err_o;
    wire pre_dec_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_i(addr_i),
        .pre_dec_err_o(pre_dec_err_o),
        .pre_dec_o(pre_dec_o)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Address 6'h00 (Domain 0)", test_num);
        addr_i = 6'h00;

        #1;


        check_outputs(0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Address 6'h0F (Domain 0 Boundary)", test_num);
        addr_i = 6'h0F;

        #1;


        check_outputs(0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Address 6'h10 (Domain 1 Start)", test_num);
        addr_i = 6'h10;

        #1;


        check_outputs(0, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Address 6'h1F (Domain 1 Boundary)", test_num);
        addr_i = 6'h1F;

        #1;


        check_outputs(0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Address 6'h20 (Invalid Range)", test_num);
        addr_i = 6'h20;

        #1;


        check_outputs(1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Address 6'h3F (Max Invalid Range)", test_num);
        addr_i = 6'h3F;

        #1;


        check_outputs(1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Address 6'h08 (Mid Domain 0)", test_num);
        addr_i = 6'h08;
        #1;

        check_outputs(0, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Address 6'h18 (Mid Domain 1)", test_num);
        addr_i = 6'h18;
        #1;

        check_outputs(0, 1);
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
        input expected_pre_dec_err_o;
        input expected_pre_dec_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pre_dec_err_o === (expected_pre_dec_err_o ^ pre_dec_err_o ^ expected_pre_dec_err_o) &&
                expected_pre_dec_o === (expected_pre_dec_o ^ pre_dec_o ^ expected_pre_dec_o)) begin
                $display("PASS");
                $display("  Outputs: pre_dec_err_o=%b, pre_dec_o=%b",
                         pre_dec_err_o, pre_dec_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pre_dec_err_o=%b, pre_dec_o=%b",
                         expected_pre_dec_err_o, expected_pre_dec_o);
                $display("  Got:      pre_dec_err_o=%b, pre_dec_o=%b",
                         pre_dec_err_o, pre_dec_o);
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
