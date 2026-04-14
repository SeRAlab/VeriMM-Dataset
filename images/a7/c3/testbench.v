`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    reg [1:0] C;
    reg [1:0] D;
    reg [1:0] S0;
    reg [1:0] S1;
    wire [1:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .S0(S0),
        .S1(S1),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 2'b01; B = 2'b10; C = 2'b11; D = 2'b00;
            S1 = 0; S0 = 0;
            $display("Test %0d: Select A ({S1,S0}=00)", test_num);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 2'b01; B = 2'b10; C = 2'b11; D = 2'b00;
            S1 = 0; S0 = 1;
            $display("Test %0d: Select B ({S1,S0}=01)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 2'b01; B = 2'b10; C = 2'b11; D = 2'b00;
            S1 = 1; S0 = 0;
            $display("Test %0d: Select C ({S1,S0}=10)", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 2'b01; B = 2'b10; C = 2'b11; D = 2'b00;
            S1 = 1; S0 = 1;
            $display("Test %0d: Select D ({S1,S0}=11)", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 2'b11; B = 2'b11; C = 2'b11; D = 2'b11;
            S1 = 1; S0 = 0;
            $display("Test %0d: All inputs identical", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 2'b00; B = 2'b01; C = 2'b10; D = 2'b11;
            S1 = 1; S0 = 1;
            #5;
            D = 2'b10;
            $display("Test %0d: Change value on active channel", test_num);
            #1;

            check_outputs(2'b10);
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
