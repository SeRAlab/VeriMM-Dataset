`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] v1_reg_0;
    wire comp1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .v1_reg_0(v1_reg_0),
        .comp1(comp1)
    );
    task testcase001;

    begin
        $display("Running testcase001: v1_reg_0 = 0");
        v1_reg_0 = 5'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: v1_reg_0 = 7");
        v1_reg_0 = 5'd7;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: v1_reg_0 = 12");
        v1_reg_0 = 5'd12;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: v1_reg_0 = 15");
        v1_reg_0 = 5'd15;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: v1_reg_0 = 16");
        v1_reg_0 = 5'd16;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: v1_reg_0 = 20");
        v1_reg_0 = 5'd20;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("Running testcase007: v1_reg_0 = 27");
        v1_reg_0 = 5'd27;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        $display("Running testcase008: v1_reg_0 = 31");
        v1_reg_0 = 5'd31;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        $display("Running testcase009: v1_reg_0 = 21");
        v1_reg_0 = 5'b10101;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        $display("Running testcase010: v1_reg_0 = 10");
        v1_reg_0 = 5'b01010;
        #1;

        check_outputs(1'b0);
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
        input expected_comp1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_comp1 === (expected_comp1 ^ comp1 ^ expected_comp1)) begin
                $display("PASS");
                $display("  Outputs: comp1=%b",
                         comp1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comp1=%b",
                         expected_comp1);
                $display("  Got:      comp1=%b",
                         comp1);
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
