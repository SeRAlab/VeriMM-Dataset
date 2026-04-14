`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] adr_An;
    reg [1:0] ptr;
    wire seg_P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adr_An(adr_An),
        .ptr(ptr),
        .seg_P(seg_P)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All zeros match (ptr=00, adr_An=00)", test_num);
        ptr = 2'b00;
        adr_An = 2'b00;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All ones match (ptr=11, adr_An=11)", test_num);
        ptr = 2'b11;
        adr_An = 2'b11;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Partial match (ptr=01, adr_An=01)", test_num);
        ptr = 2'b01;
        adr_An = 2'b01;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Inequality - Different lower bit (ptr=00, adr_An=01)", test_num);
        ptr = 2'b00;
        adr_An = 2'b01;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Inequality - Different upper bit (ptr=10, adr_An=00)", test_num);
        ptr = 2'b10;
        adr_An = 2'b00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Inequality - Both bits different (ptr=11, adr_An=00)", test_num);
        ptr = 2'b11;
        adr_An = 2'b00;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Inequality - Bit reversal (ptr=01, adr_An=10)", test_num);
        ptr = 2'b01;
        adr_An = 2'b10;
        #1;

        check_outputs(1'b1);
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
        input expected_seg_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg_P === (expected_seg_P ^ seg_P ^ expected_seg_P)) begin
                $display("PASS");
                $display("  Outputs: seg_P=%b",
                         seg_P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg_P=%b",
                         expected_seg_P);
                $display("  Got:      seg_P=%b",
                         seg_P);
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
