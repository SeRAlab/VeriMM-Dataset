`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] In;
    reg [4:0] ShiftAmount;
    reg ShiftType;
    wire [31:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In(In),
        .ShiftAmount(ShiftAmount),
        .ShiftType(ShiftType),
        .Out(Out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Logical Left Shift by 0", test_num);
            In = 32'h12345678;
            ShiftType = 0;
            ShiftAmount = 5'd0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Logical Left Shift by 1", test_num);
            In = 32'h00000001;
            ShiftType = 0;
            ShiftAmount = 5'd1;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Logical Left Shift by 8", test_num);
            In = 32'h000000FF;
            ShiftType = 0;
            ShiftAmount = 5'd8;
            #1;

            check_outputs(32'h0000FF00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Logical Left Shift by 31", test_num);
            In = 32'h00000001;
            ShiftType = 0;
            ShiftAmount = 5'd31;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Logical Right Shift by 0", test_num);
            In = 32'h87654321;
            ShiftType = 1;
            ShiftAmount = 5'd0;
            #1;

            check_outputs(32'h87654321);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Logical Right Shift by 1", test_num);
            In = 32'h80000000;
            ShiftType = 1;
            ShiftAmount = 5'd1;
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Logical Right Shift by 16", test_num);
            In = 32'hFFFF0000;
            ShiftType = 1;
            ShiftAmount = 5'd16;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Logical Right Shift by 31", test_num);
            In = 32'h80000000;
            ShiftType = 1;
            ShiftAmount = 5'd31;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Logical Left Shift Overflow (All 1s)", test_num);
            In = 32'hFFFFFFFF;
            ShiftType = 0;
            ShiftAmount = 5'd4;
            #1;

            check_outputs(32'hFFFFFFF0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Logical Right Shift Underflow (All 1s)", test_num);
            In = 32'hFFFFFFFF;
            ShiftType = 1;
            ShiftAmount = 5'd4;
            #1;

            check_outputs(32'h0FFFFFFF);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test %0d: Alternating Bits Left Shift", test_num);
            In = 32'hAAAAAAAA;
            ShiftType = 0;
            ShiftAmount = 5'd1;
            #1;

            check_outputs(32'h55555554);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test %0d: Alternating Bits Right Shift", test_num);
            In = 32'hAAAAAAAA;
            ShiftType = 1;
            ShiftAmount = 5'd1;
            #1;

            check_outputs(32'h55555555);
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
        input [31:0] expected_Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
