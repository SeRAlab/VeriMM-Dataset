`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg Ah;
    reg [1:0] B;
    reg Bh;
    wire [1:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .Ah(Ah),
        .B(B),
        .Bh(Bh),
        .Q(Q)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 2'b00; Ah = 1'b0; B = 2'b00; Bh = 1'b0;
            $display("Test %0d: All inputs zero", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 2'b01; Ah = 1'b0; B = 2'b01; Bh = 1'b0;
            $display("Test %0d: Identity multiplication (A=1, B=1)", test_num);

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 2'b00; Ah = 1'b1; B = 2'b00; Bh = 1'b1;
            $display("Test %0d: Scaling logic only (Ah=1, Bh=1)", test_num);


            #1;



            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 2'b10; Ah = 1'b0; B = 2'b10; Bh = 1'b0;
            $display("Test %0d: Higher base bits (A=2, B=2)", test_num);
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 2'b11; Ah = 1'b1; B = 2'b11; Bh = 1'b1;
            $display("Test %0d: All bits high", test_num);

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 2'b01; Ah = 1'b1; B = 2'b10; Bh = 1'b0;
            $display("Test %0d: Asymmetric inputs (A=1, Ah=1, B=2, Bh=0)", test_num);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 2'b11; Ah = 1'b1; B = 2'b00; Bh = 1'b0;
            $display("Test %0d: Zero B side", test_num);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 2'b11; Ah = 1'b1; B = 2'b01; Bh = 1'b1;
            $display("Test %0d: Maximum scaling influence", test_num);
            #1;

            check_outputs(2'b01);
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
        input [1:0] expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
