`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .z(z)
    );
    task testcase001;

    begin
        A = 2'b00; B = 2'b00;
        test_num = test_num + 1;
        $display("Test %0d: A=%b, B=%b (Equal zeros)", test_num, A, B);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        A = 2'b01; B = 2'b01;
        test_num = test_num + 1;
        $display("Test %0d: A=%b, B=%b (Equal ones)", test_num, A, B);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        A = 2'b10; B = 2'b10;
        test_num = test_num + 1;
        $display("Test %0d: A=%b, B=%b (Equal values)", test_num, A, B);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        A = 2'b11; B = 2'b11;
        test_num = test_num + 1;
        $display("Test %0d: A=%b, B=%b (Equal max)", test_num, A, B);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        A = 2'b00; B = 2'b01;
        test_num = test_num + 1;
        $display("Test %0d: A=%b, B=%b (Unequal LSB)", test_num, A, B);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        A = 2'b01; B = 2'b00;
        test_num = test_num + 1;
        $display("Test %0d: A=%b, B=%b (Unequal LSB reverse)", test_num, A, B);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        A = 2'b10; B = 2'b00;
        test_num = test_num + 1;
        $display("Test %0d: A=%b, B=%b (Unequal MSB)", test_num, A, B);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        A = 2'b11; B = 2'b00;
        test_num = test_num + 1;
        $display("Test %0d: A=%b, B=%b (Unequal both bits)", test_num, A, B);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        A = 2'b01; B = 2'b10;
        test_num = test_num + 1;
        $display("Test %0d: A=%b, B=%b (Unequal mixed bits)", test_num, A, B);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        A = 2'b10; B = 2'b11;
        test_num = test_num + 1;
        $display("Test %0d: A=%b, B=%b (Unequal high range)", test_num, A, B);
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
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%b",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%b",
                         expected_z);
                $display("  Got:      z=%b",
                         z);
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
