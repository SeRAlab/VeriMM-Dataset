`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    reg ab;
    reg cd;
    wire [1:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .ab(ab),
        .cd(cd),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 2'b00; B = 2'b00; ab = 1'b0; cd = 1'b0;
        $display("Test %0d: All inputs zero", test_num);
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 2'b00; B = 2'b00; ab = 1'b1; cd = 1'b1;
        $display("Test %0d: Only control bits active", test_num);
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 2'b01; B = 2'b01; ab = 1'b0; cd = 1'b0;
        $display("Test %0d: Data bits A[0], B[0] active", test_num);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 2'b10; B = 2'b10; ab = 1'b0; cd = 1'b0;
        $display("Test %0d: Data bits A[1], B[1] active", test_num);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 2'b01; B = 2'b01; ab = 1'b1; cd = 1'b1;
        $display("Test %0d: Interaction between data[0] and control", test_num);
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 2'b10; B = 2'b10; ab = 1'b1; cd = 1'b1;
        $display("Test %0d: Interaction between data[1] and control", test_num);
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 2'b11; B = 2'b11; ab = 1'b1; cd = 1'b0;
        $display("Test %0d: One control bit active", test_num);
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 2'b11; B = 2'b11; ab = 1'b1; cd = 1'b1;
        $display("Test %0d: All inputs active", test_num);
        #1;

        check_outputs(2'b00);
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
        input [1:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
