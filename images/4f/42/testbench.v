`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ctrl;
    reg [3:0] in1;
    reg [3:0] in2;
    wire cout;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .in1(in1),
        .in2(in2),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        in1 = 4'd5;
        in2 = 4'd3;
        ctrl = 1'b0;
        $display("Testcase %0d: in1=5, in2=3, ctrl=0 (Expect Sum=8, Cout=0)", test_num);
        #1;

        check_outputs(1'b0, 4'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        in1 = 4'd5;
        in2 = 4'd3;
        ctrl = 1'b1;
        $display("Testcase %0d: in1=5, in2=3, ctrl=1 (Expect Sum=0, Cout=0)", test_num);
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        in1 = 4'd12;
        in2 = 4'd7;
        ctrl = 1'b0;
        $display("Testcase %0d: in1=12, in2=7, ctrl=0 (Expect Sum=3, Cout=0)", test_num);
        #1;

        check_outputs(1'b0, 4'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        in1 = 4'd12;
        in2 = 4'd7;
        ctrl = 1'b1;
        $display("Testcase %0d: in1=12, in2=7, ctrl=1 (Expect Sum=0, Cout=1)", test_num);
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        in1 = 4'd15;
        in2 = 4'd15;
        ctrl = 1'b0;
        $display("Testcase %0d: in1=15, in2=15, ctrl=0 (Expect Sum=14, Cout=0)", test_num);
        #1;

        check_outputs(1'b0, 4'd14);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        in1 = 4'd15;
        in2 = 4'd15;
        ctrl = 1'b1;
        $display("Testcase %0d: in1=15, in2=15, ctrl=1 (Expect Sum=0, Cout=1)", test_num);
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        in1 = 4'd0;
        in2 = 4'd0;
        ctrl = 1'b0;
        $display("Testcase %0d: in1=0, in2=0, ctrl=0 (Expect Sum=0, Cout=0)", test_num);
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        in1 = 4'd0;
        in2 = 4'd0;
        ctrl = 1'b1;
        $display("Testcase %0d: in1=0, in2=0, ctrl=1 (Expect Sum=0, Cout=0)", test_num);
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        in1 = 4'd8;
        in2 = 4'd8;
        ctrl = 1'b0;
        $display("Testcase %0d: in1=8, in2=8, ctrl=0 (Expect Sum=0, Cout=0)", test_num);
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        in1 = 4'd8;
        in2 = 4'd8;
        ctrl = 1'b1;
        $display("Testcase %0d: in1=8, in2=8, ctrl=1 (Expect Sum=0, Cout=1)", test_num);
        #1;

        check_outputs(1'b1, 4'd0);
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
        input expected_cout;
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, sum=%h",
                         cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, sum=%h",
                         expected_cout, expected_sum);
                $display("  Got:      cout=%b, sum=%h",
                         cout, sum);
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
