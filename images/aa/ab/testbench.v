`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg LA;
    reg LR;
    wire C;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .LA(LA),
        .LR(LR),
        .C(C),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Logical Left Shift (LA=0, LR=0) - No Carry", test_num);
        A = 8'h01; LA = 0; LR = 0;
        #1;

        check_outputs(1'b0, 8'h02);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Logical Left Shift (LA=0, LR=0) - With Carry", test_num);
        A = 8'h81; LA = 0; LR = 0;
        #1;

        check_outputs(1'b1, 8'h02);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Logical Left Shift (LA=0, LR=0) - Max Value", test_num);
        A = 8'hFF; LA = 0; LR = 0;
        #1;

        check_outputs(1'b1, 8'hFE);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Logical Right Shift (LA=0, LR=1) - No Carry", test_num);
        A = 8'h80; LA = 0; LR = 1;
        #1;

        check_outputs(1'b0, 8'h40);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Logical Right Shift (LA=0, LR=1) - With Carry", test_num);
        A = 8'h81; LA = 0; LR = 1;
        #1;

        check_outputs(1'b1, 8'h40);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Logical Right Shift (LA=0, LR=1) - Max Value", test_num);
        A = 8'hFF; LA = 0; LR = 1;
        #1;

        check_outputs(1'b1, 8'h7F);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Arithmetic Right Shift (LA=1, LR=1) - MSB 1, Carry 0", test_num);
        A = 8'h80; LA = 1; LR = 1;
        #1;

        check_outputs(1'b0, 8'hC0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Arithmetic Right Shift (LA=1, LR=1) - MSB 1, Carry 1", test_num);
        A = 8'h81; LA = 1; LR = 1;
        #1;

        check_outputs(1'b1, 8'hC0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Arithmetic Right Shift (LA=1, LR=1) - MSB 0, Carry 1", test_num);
        A = 8'h41; LA = 1; LR = 1;
        #1;

        check_outputs(1'b1, 8'h20);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Arithmetic Right Shift (LA=1, LR=1) - All Ones", test_num);
        A = 8'hFF; LA = 1; LR = 1;
        #1;

        check_outputs(1'b1, 8'hFF);
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
        input expected_C;
        input [7:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: C=%b, Y=%h",
                         C, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, Y=%h",
                         expected_C, expected_Y);
                $display("  Got:      C=%b, Y=%h",
                         C, Y);
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
