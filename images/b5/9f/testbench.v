`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    wire ov;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .ov(ov),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 4'd0;
        b = 4'd0;
        c = 4'd0;
        $display("Testcase %0d: All zeros (0+0+0=0, ov=0)", test_num);
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 4'd2;
        b = 4'd3;
        c = 4'd4;
        $display("Testcase %0d: Small sum no overflow (2+3+4=9, ov=0)", test_num);
        #1;

        check_outputs(1'b0, 4'd9);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 4'd5;
        b = 4'd5;
        c = 4'd5;
        $display("Testcase %0d: Boundary sum no overflow (5+5+5=15, ov=0)", test_num);
        #1;

        check_outputs(1'b0, 4'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 4'd5;
        b = 4'd5;
        c = 4'd6;
        $display("Testcase %0d: Minimum overflow (5+5+6=16, ov=1, sum=0)", test_num);
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 4'd10;
        b = 4'd10;
        c = 4'd10;
        $display("Testcase %0d: Large sum with overflow (10+10+10=30, ov=1, sum=14)", test_num);
        #1;

        check_outputs(1'b1, 4'd14);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 4'd15;
        b = 4'd15;
        c = 4'd15;
        $display("Testcase %0d: Maximum possible sum (15+15+15=45, ov=1, sum=13)", test_num);
        #1;

        check_outputs(1'b1, 4'd13);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 4'd15;
        b = 4'd0;
        c = 4'd0;
        $display("Testcase %0d: Single max input (15+0+0=15, ov=0)", test_num);
        #1;

        check_outputs(1'b0, 4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 4'd8;
        b = 4'd8;
        c = 4'd1;
        $display("Testcase %0d: Overflow on two inputs (8+8+1=17, ov=1, sum=1)", test_num);
        #1;

        check_outputs(1'b1, 4'd1);
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
        input expected_ov;
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ov === (expected_ov ^ ov ^ expected_ov) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: ov=%b, sum=%h",
                         ov, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ov=%b, sum=%h",
                         expected_ov, expected_sum);
                $display("  Got:      ov=%b, sum=%h",
                         ov, sum);
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
