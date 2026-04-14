`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] BOp;
    reg [31:0] D1;
    reg [31:0] D2;
    wire Less;
    wire More;
    wire Zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BOp(BOp),
        .D1(D1),
        .D2(D2),
        .Less(Less),
        .More(More),
        .Zero(Zero)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: D1 > D2 (Direct Mode)", test_num);
        BOp = 4'b0000;
        D1 = 32'd1000;
        D2 = 32'd500;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: D1 < D2 (Direct Mode)", test_num);
        BOp = 4'b0000;
        D1 = 32'd25;
        D2 = 32'd75;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: D1 == D2 (Direct Mode)", test_num);
        BOp = 4'b0000;
        D1 = 32'hABCDE000;
        D2 = 32'hABCDE000;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: D1 > 0 (Zero Mode, D2 ignored)", test_num);
        BOp = 4'b0001;
        D1 = 32'd1;
        D2 = 32'd9999;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: D1 == 0 (Zero Mode)", test_num);
        BOp = 4'b0001;
        D1 = 32'd0;
        D2 = 32'd50;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max Unsigned Comparison", test_num);
        BOp = 4'b0000;
        D1 = 32'hFFFF_FFFF;
        D2 = 32'hFFFF_FFFE;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Sign Bit Set vs Zero Mode", test_num);
        BOp = 4'b0001;
        D1 = 32'h8000_0000;
        D2 = 32'd0;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0);
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
        input expected_Less;
        input expected_More;
        input expected_Zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Less === (expected_Less ^ Less ^ expected_Less) &&
                expected_More === (expected_More ^ More ^ expected_More) &&
                expected_Zero === (expected_Zero ^ Zero ^ expected_Zero)) begin
                $display("PASS");
                $display("  Outputs: Less=%b, More=%b, Zero=%b",
                         Less, More, Zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Less=%b, More=%b, Zero=%b",
                         expected_Less, expected_More, expected_Zero);
                $display("  Got:      Less=%b, More=%b, Zero=%b",
                         Less, More, Zero);
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
