`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [4:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Positive addition (3 + 2 = 5)", test_num);
        A = 4'b0011;
        B = 4'b0010;
        #1;

        check_outputs(5'b00101);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative addition (-1 + -1 = -2)", test_num);
        A = 4'b1111;
        B = 4'b1111;
        #1;

        check_outputs(5'b11110);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max positive overflow check (7 + 7 = 14)", test_num);
        A = 4'b0111;
        B = 4'b0111;
        #1;

        check_outputs(5'b01110);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max negative overflow check (-8 + -8 = -16)", test_num);
        A = 4'b1000;
        B = 4'b1000;
        #1;

        check_outputs(5'b10000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed signs result negative (2 + -5 = -3)", test_num);
        A = 4'b0010;
        B = 4'b1011;
        #1;

        check_outputs(5'b11101);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed signs result positive (5 + -2 = 3)", test_num);
        A = 4'b0101;
        B = 4'b1110;
        #1;

        check_outputs(5'b00011);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero addition (0 + 0 = 0)", test_num);
        A = 4'b0000;
        B = 4'b0000;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary mixed signs (7 + -8 = -1)", test_num);
        A = 4'b0111;
        B = 4'b1000;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero result (-4 + 4 = 0)", test_num);
        A = 4'b1100;
        B = 4'b0100;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large negative plus small positive (-8 + 1 = -7)", test_num);
        A = 4'b1000;
        B = 4'b0001;
        #1;

        check_outputs(5'b11001);
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
        input [4:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
