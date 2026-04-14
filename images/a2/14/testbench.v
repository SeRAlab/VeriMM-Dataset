`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    wire C;
    wire [1:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A=0, B=0 (Zero Addition)", test_num);
            A = 2'b00; B = 2'b00;
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A=1, B=0 (LSB Only)", test_num);
            A = 2'b01; B = 2'b00;
            #1;

            check_outputs(1'b0, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A=1, B=1 (Internal Carry)", test_num);
            A = 2'b01; B = 2'b01;
            #1;

            check_outputs(1'b0, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A=2, B=1 (MSB No Carry-out)", test_num);
            A = 2'b10; B = 2'b01;
            #1;

            check_outputs(1'b0, 2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A=2, B=2 (Overflow Boundary)", test_num);
            A = 2'b10; B = 2'b10;
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A=3, B=1 (Internal + Carry-out)", test_num);
            A = 2'b11; B = 2'b01;
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A=3, B=2", test_num);
            A = 2'b11; B = 2'b10;
            #1;

            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: A=3, B=3 (Max Values)", test_num);
            A = 2'b11; B = 2'b11;
            #1;

            check_outputs(1'b1, 2'b10);
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
        input expected_C;
        input [1:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: C=%b, S=%h",
                         C, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, S=%h",
                         expected_C, expected_S);
                $display("  Got:      C=%b, S=%h",
                         C, S);
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
