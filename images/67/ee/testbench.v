`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [1:0] control;
    wire [3:0] X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .control(control),
        .X(X)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Control 00 (Direct A) - A=4'b1000", test_num);
        A = 4'b1000;
        control = 2'b00;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Control 01 (Rotate Left) - A=4'b1000", test_num);
        A = 4'b1000;
        control = 2'b01;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Control 10 (Rotate Right) - A=4'b1000", test_num);
        A = 4'b1000;
        control = 2'b10;
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Control 11 (Rotate Left Wrap) - A=4'b1000", test_num);
        A = 4'b1000;
        control = 2'b11;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Control 00 (Direct A) - A=4'b1100", test_num);
        A = 4'b1100;
        control = 2'b00;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Control 01 (Rotate Left) - A=4'b1100", test_num);
        A = 4'b1100;
        control = 2'b01;
        #1;

        check_outputs(4'b1001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Control 10 (Rotate Right) - A=4'b1100", test_num);
        A = 4'b1100;
        control = 2'b10;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Control 11 (Rotate Left Wrap) - A=4'b1100", test_num);
        A = 4'b1100;
        control = 2'b11;
        #1;

        check_outputs(4'b1001);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Rotating 4'b0001 Left", test_num);
        A = 4'b0001;
        control = 2'b01;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Rotating 4'b0001 Right", test_num);
        A = 4'b0001;
        control = 2'b10;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Edge case A=4'b1111", test_num);
        A = 4'b1111;
        control = 2'b01;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Edge case A=4'b0000", test_num);
        A = 4'b0000;
        control = 2'b10;
        #1;

        check_outputs(4'b0000);
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
        input [3:0] expected_X;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%h",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%h",
                         expected_X);
                $display("  Got:      X=%h",
                         X);
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
