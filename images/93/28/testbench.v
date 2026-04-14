`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    wire [3:0] s1;
    wire [3:0] s2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .s1(s1),
        .s2(s2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs zero", test_num);
            a = 4'h0; b = 4'h0; c = 4'h0;
            #1;

            check_outputs(4'hF, 4'hF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs high", test_num);
            a = 4'hF; b = 4'hF; c = 4'hF;
            #1;

            check_outputs(4'h0, 4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Differing inputs with control high", test_num);
            a = 4'hF; b = 4'h0; c = 4'hF;
            #1;

            check_outputs(4'hF, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Differing inputs with control low", test_num);
            a = 4'hF; b = 4'h0; c = 4'h0;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise alternating pattern", test_num);
            a = 4'h5; b = 4'hA; c = 4'hF;
            #1;

            check_outputs(4'hF, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Same inputs (partially low) with control high", test_num);
            a = 4'h3; b = 4'h3; c = 4'hF;
            #1;

            check_outputs(4'hC, 4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Same inputs (partially low) with control low", test_num);
            a = 4'hC; b = 4'hC; c = 4'h0;
            #1;

            check_outputs(4'h3, 4'h3);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed bit patterns", test_num);
            a = 4'b1100; b = 4'b1010; c = 4'b0110;


            #1;



            check_outputs(4'h7, 4'h1);
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
        input [3:0] expected_s1;
        input [3:0] expected_s2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s1 === (expected_s1 ^ s1 ^ expected_s1) &&
                expected_s2 === (expected_s2 ^ s2 ^ expected_s2)) begin
                $display("PASS");
                $display("  Outputs: s1=%h, s2=%h",
                         s1, s2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s1=%h, s2=%h",
                         expected_s1, expected_s2);
                $display("  Got:      s1=%h, s2=%h",
                         s1, s2);
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
