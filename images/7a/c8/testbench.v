`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    reg [7:0] D;
    reg E;
    reg [1:0] S;
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
        .E(E),
        .S(S),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: E=0, S=00 (Expected Y=0)", test_num);
        A = 8'hAA; B = 8'hBB; C = 8'hCC; D = 8'hDD;
        E = 0;
        S = 2'b00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: E=0, S=11 (Expected Y=0)", test_num);
        A = 8'hAA; B = 8'hBB; C = 8'hCC; D = 8'hDD;
        E = 0;
        S = 2'b11;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: E=1, S=00 (Select A)", test_num);
        A = 8'h12; B = 8'h34; C = 8'h56; D = 8'h78;
        E = 1;
        S = 2'b00;
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: E=1, S=01 (Select B)", test_num);
        A = 8'h12; B = 8'h34; C = 8'h56; D = 8'h78;
        E = 1;
        S = 2'b01;
        #1;

        check_outputs(8'h34);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: E=1, S=10 (Select C)", test_num);
        A = 8'h12; B = 8'h34; C = 8'h56; D = 8'h78;
        E = 1;
        S = 2'b10;
        #1;

        check_outputs(8'h56);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: E=1, S=11 (Select D)", test_num);
        A = 8'h12; B = 8'h34; C = 8'h56; D = 8'h78;
        E = 1;
        S = 2'b11;
        #1;

        check_outputs(8'h78);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: E=1, S=00, Changing input A", test_num);
        A = 8'hFF; B = 8'h00; C = 8'h00; D = 8'h00;
        E = 1;
        S = 2'b00;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: E=1, S=10, All inputs zero", test_num);
        A = 8'h00; B = 8'h00; C = 8'h00; D = 8'h00;
        E = 1;
        S = 2'b10;
        #1;

        check_outputs(8'h00);
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
