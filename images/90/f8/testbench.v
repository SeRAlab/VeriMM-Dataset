`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg A3;
    reg B1;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .B1(B1),
        .X(X)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            {A1, A2, A3, B1} = 4'b0000;
            #10;
            $display("Test %0d: A1=0, A2=0, A3=0, B1=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            {A1, A2, A3, B1} = 4'b0001;
            #10;
            $display("Test %0d: A1=0, A2=0, A3=0, B1=1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            {A1, A2, A3, B1} = 4'b0010;
            #10;
            $display("Test %0d: A1=0, A2=0, A3=1, B1=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            {A1, A2, A3, B1} = 4'b0011;
            #10;
            $display("Test %0d: A1=0, A2=0, A3=1, B1=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            {A1, A2, A3, B1} = 4'b0100;
            #10;
            $display("Test %0d: A1=0, A2=1, A3=0, B1=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            {A1, A2, A3, B1} = 4'b0101;
            #10;
            $display("Test %0d: A1=0, A2=1, A3=0, B1=1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            {A1, A2, A3, B1} = 4'b0110;
            #10;
            $display("Test %0d: A1=0, A2=1, A3=1, B1=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            {A1, A2, A3, B1} = 4'b0111;
            #10;
            $display("Test %0d: A1=0, A2=1, A3=1, B1=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            {A1, A2, A3, B1} = 4'b1000;
            #10;
            $display("Test %0d: A1=1, A2=0, A3=0, B1=0", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            {A1, A2, A3, B1} = 4'b1011;
            #10;
            $display("Test %0d: A1=1, A2=0, A3=1, B1=1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            {A1, A2, A3, B1} = 4'b1100;
            #10;
            $display("Test %0d: A1=1, A2=1, A3=0, B1=0", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            {A1, A2, A3, B1} = 4'b1111;
            #10;
            $display("Test %0d: A1=1, A2=1, A3=1, B1=1", test_num);
            #1;

            check_outputs(1'b1);
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
        input expected_X;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%b",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%b",
                         expected_X);
                $display("  Got:      X=%b",
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
