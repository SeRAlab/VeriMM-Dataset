`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg [7:0] D;
    reg S0;
    reg S1;
    wire [7:0] Y;

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
        test_num = test_num + 1;
        A = 8'hA1; B = 8'hB2; C = 8'hC3; D = 8'hD4;
        S1 = 0; S0 = 0;
        #1;

        check_outputs(8'hA1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 8'hA1; B = 8'hB2; C = 8'hC3; D = 8'hD4;
        S1 = 0; S0 = 1;
        #1;

        check_outputs(8'hB2);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 8'hA1; B = 8'hB2; C = 8'hC3; D = 8'hD4;
        S1 = 1; S0 = 0;
        #1;

        check_outputs(8'hC3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 8'hA1; B = 8'hB2; C = 8'hC3; D = 8'hD4;
        S1 = 1; S0 = 1;
        #1;

        check_outputs(8'hD4);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 8'hFF; B = 8'h00; C = 8'h55; D = 8'hAA;


        S1 = 0; S0 = 1;
        #1;

        check_outputs(8'h00);


        S1 = 0; S0 = 0;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 8'h10; B = 8'h20; C = 8'h30; D = 8'h40;

        S1 = 1; S0 = 1; #5;
        S1 = 1; S0 = 0;
        #1;

        check_outputs(8'h30);
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
        input [7:0] expected_Y;
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
