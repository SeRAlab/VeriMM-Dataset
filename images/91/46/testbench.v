`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] ccr;
    reg [3:0] cond;
    wire condition;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ccr(ccr),
        .cond(cond),
        .condition(condition)
    );
    task testcase001;

    begin
        test_num = 1;
        cond = 4'b0000;
        ccr = 8'b0000_0100;
        $display("Test %0d: EQ with Z=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        cond = 4'b0000;
        ccr = 8'b0000_0000;
        $display("Test %0d: EQ with Z=0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        cond = 4'b0001;
        ccr = 8'b0000_0000;
        $display("Test %0d: NE with Z=0", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        cond = 4'b0010;
        ccr = 8'b0000_0001;
        $display("Test %0d: CS with C=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        cond = 4'b0100;
        ccr = 8'b0000_1000;
        $display("Test %0d: MI with N=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        cond = 4'b0110;
        ccr = 8'b0000_0010;
        $display("Test %0d: VS with V=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        cond = 4'b1000;
        ccr = 8'b0000_0001;
        $display("Test %0d: HI with C=1, Z=0", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        cond = 4'b1000;
        ccr = 8'b0000_0101;
        $display("Test %0d: HI with C=1, Z=1", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        cond = 4'b1010;
        ccr = 8'b0000_1010;
        $display("Test %0d: GE with N=1, V=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        cond = 4'b1011;
        ccr = 8'b0000_1000;
        $display("Test %0d: LT with N=1, V=0", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        cond = 4'b1100;
        ccr = 8'b0000_0000;
        $display("Test %0d: GT with Z=0, N=0, V=0", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        cond = 4'b1101;
        ccr = 8'b0000_0100;
        $display("Test %0d: LE with Z=1", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        cond = 4'b1110;
        ccr = 8'b1010_1010;
        $display("Test %0d: AL (Always True)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        cond = 4'b1111;
        ccr = 8'b1111_1111;
        $display("Test %0d: NV (Never True)", test_num);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        
        
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
        input expected_condition;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_condition === (expected_condition ^ condition ^ expected_condition)) begin
                $display("PASS");
                $display("  Outputs: condition=%b",
                         condition);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: condition=%b",
                         expected_condition);
                $display("  Got:      condition=%b",
                         condition);
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
