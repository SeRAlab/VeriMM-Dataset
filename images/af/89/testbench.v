`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg WrEn;
    reg [1:0] sel;
    wire r0;
    wire r1;
    wire r2;
    wire r3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .WrEn(WrEn),
        .sel(sel),
        .r0(r0),
        .r1(r1),
        .r2(r2),
        .r3(r3)
    );
    task testcase001;

    begin
        test_num = 1;
        WrEn = 0;
        sel = 2'b00;
        $display("Test %0d: WrEn=0, sel=00", test_num);
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        WrEn = 0;
        sel = 2'b01;
        $display("Test %0d: WrEn=0, sel=01", test_num);
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        WrEn = 0;
        sel = 2'b10;
        $display("Test %0d: WrEn=0, sel=10", test_num);
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        WrEn = 0;
        sel = 2'b11;
        $display("Test %0d: WrEn=0, sel=11", test_num);
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        WrEn = 1;
        sel = 2'b00;
        $display("Test %0d: WrEn=1, sel=00 (Expect r0)", test_num);
        #1;

        check_outputs(1'b1, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        WrEn = 1;
        sel = 2'b01;
        $display("Test %0d: WrEn=1, sel=01 (Expect r1)", test_num);
        #1;

        check_outputs(1'b0, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        WrEn = 1;
        sel = 2'b10;
        $display("Test %0d: WrEn=1, sel=10 (Expect r2)", test_num);
        #1;

        check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        WrEn = 1;
        sel = 2'b11;
        $display("Test %0d: WrEn=1, sel=11 (Expect r3)", test_num);
        #1;

        check_outputs(1'b0, 1'b0, 1'b0, 1'b1);
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
        input expected_r0;
        input expected_r1;
        input expected_r2;
        input expected_r3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_r0 === (expected_r0 ^ r0 ^ expected_r0) &&
                expected_r1 === (expected_r1 ^ r1 ^ expected_r1) &&
                expected_r2 === (expected_r2 ^ r2 ^ expected_r2) &&
                expected_r3 === (expected_r3 ^ r3 ^ expected_r3)) begin
                $display("PASS");
                $display("  Outputs: r0=%b, r1=%b, r2=%b, r3=%b",
                         r0, r1, r2, r3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r0=%b, r1=%b, r2=%b, r3=%b",
                         expected_r0, expected_r1, expected_r2, expected_r3);
                $display("  Got:      r0=%b, r1=%b, r2=%b, r3=%b",
                         r0, r1, r2, r3);
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
