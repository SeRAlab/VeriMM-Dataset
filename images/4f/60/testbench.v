`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg [1:0] S;
    wire [3:0] Y;

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
        .S(S),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Select A (S=00)", test_num);
        A = 4'hA; B = 4'h0; C = 4'h0; D = 4'h0;
        S = 2'b00;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Select B (S=01)", test_num);
        A = 4'h0; B = 4'hB; C = 4'h0; D = 4'h0;
        S = 2'b01;
        #1;

        check_outputs(4'hB);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Select C (S=10)", test_num);
        A = 4'h0; B = 4'h0; C = 4'hC; D = 4'h0;
        S = 2'b10;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Select D (S=11)", test_num);
        A = 4'h0; B = 4'h0; C = 4'h0; D = 4'hD;
        S = 2'b11;
        #1;

        check_outputs(4'hD);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: All inputs different patterns, Select A", test_num);
        A = 4'b1010; B = 4'b0101; C = 4'b1111; D = 4'b0000;
        S = 2'b00;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: All inputs different patterns, Select B", test_num);
        A = 4'b1010; B = 4'b0101; C = 4'b1111; D = 4'b0000;
        S = 2'b01;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: All inputs different patterns, Select C", test_num);
        A = 4'b1010; B = 4'b0101; C = 4'b1111; D = 4'b0000;
        S = 2'b10;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: All inputs different patterns, Select D", test_num);
        A = 4'b1010; B = 4'b0101; C = 4'b1111; D = 4'b0000;
        S = 2'b11;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: All inputs logic high (F)", test_num);
        A = 4'hF; B = 4'hF; C = 4'hF; D = 4'hF;
        S = 2'b10;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Walking bit test (Select D)", test_num);
        A = 4'b0001; B = 4'b0010; C = 4'b0100; D = 4'b1000;
        S = 2'b11;
        #1;

        check_outputs(4'b1000);
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
        input [3:0] expected_Y;
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
