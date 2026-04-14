`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg S;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .S(S),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'b1010;
            B = 4'b0101;
            S = 1'b0;
            $display("Testcase %0d: Select A (S=0), A=0xA, B=0x5", test_num);
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'b1010;
            B = 4'b0101;
            S = 1'b1;
            $display("Testcase %0d: Select B (S=1), A=0xA, B=0x5", test_num);
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'h0;
            B = 4'hF;
            S = 1'b0;
            $display("Testcase %0d: Select A (S=0), A=0x0, B=0xF", test_num);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'h0;
            B = 4'hF;
            S = 1'b1;
            $display("Testcase %0d: Select B (S=1), A=0x0, B=0xF", test_num);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'b0001;
            B = 4'b1110;
            S = 1'b0;
            $display("Testcase %0d: Select A (S=0), A=0x1, B=0xE", test_num);
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'b0001;
            B = 4'b1110;
            S = 1'b1;
            $display("Testcase %0d: Select B (S=1), A=0x1, B=0xE", test_num);
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'hC;
            B = 4'hC;
            S = 1'b0;
            $display("Testcase %0d: Select A (S=0), A=0xC, B=0xC", test_num);
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'h3;
            B = 4'h3;
            S = 1'b1;
            $display("Testcase %0d: Select B (S=1), A=0x3, B=0x3", test_num);
            #1;

            check_outputs(4'h3);
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
