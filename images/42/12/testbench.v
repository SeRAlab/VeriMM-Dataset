`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg [1:0] S;
    wire Z;

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
        .Z(Z)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 4'b0001; B = 4'b0000; C = 4'b0000; D = 4'b0000; S = 2'b00;
            $display("Testcase %0d: Select A (S=00), A=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 4'b0000; B = 4'b0001; C = 4'b0000; D = 4'b0000; S = 2'b01;
            $display("Testcase %0d: Select B (S=01), B=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 4'b0000; B = 4'b0000; C = 4'b0001; D = 4'b0000; S = 2'b10;
            $display("Testcase %0d: Select C (S=10), C=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 4'b0000; B = 4'b0000; C = 4'b0000; D = 4'b0001; S = 2'b11;
            $display("Testcase %0d: Select D (S=11), D=1", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 4'b1110; B = 4'b1111; C = 4'b1111; D = 4'b1111; S = 2'b00;
            $display("Testcase %0d: Select A (S=00), A LSB=0, others=1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 4'b1111; B = 4'b1110; C = 4'b1111; D = 4'b1111; S = 2'b01;
            $display("Testcase %0d: Select B (S=01), B LSB=0, others=1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 4'b1111; B = 4'b1111; C = 4'b1110; D = 4'b1111; S = 2'b10;
            $display("Testcase %0d: Select C (S=10), C LSB=0, others=1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 4'b1111; B = 4'b1111; C = 4'b1111; D = 4'b1110; S = 2'b11;
            $display("Testcase %0d: Select D (S=11), D LSB=0, others=1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 4'b0001; B = 4'b0000; C = 4'b0001; D = 4'b0000;
            S = 2'b00; #1;
            S = 2'b01; #1;
            S = 2'b10; #1;
            S = 2'b11;
            $display("Testcase %0d: Switch selection S=00->01->10->11", test_num);
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
        input expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%b",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%b",
                         expected_Z);
                $display("  Got:      Z=%b",
                         Z);
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
