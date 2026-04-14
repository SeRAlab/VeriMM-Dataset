`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [15:0] g;
    wire [15:0] p;
    wire [15:0] x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .g(g),
        .p(p),
        .x(x)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            a = 16'h0000;
            b = 16'h0000;
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones", test_num);
            a = 16'hFFFF;
            b = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF, 16'hFFFF, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Complementary Patterns", test_num);
            a = 16'hAAAA;
            b = 16'h5555;
            #1;

            check_outputs(16'h0000, 16'hFFFF, 16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identical Patterns", test_num);
            a = 16'h1234;
            b = 16'h1234;
            #1;

            check_outputs(16'h1234, 16'h1234, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Bits", test_num);
            a = 16'h8000;
            b = 16'h0001;
            #1;

            check_outputs(16'h0000, 16'h8001, 16'h8001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arbitrary Mix", test_num);
            a = 16'hF0F0;
            b = 16'hCC33;



            #1;




            check_outputs(16'hC030, 16'hFCB3, 16'h3C83);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Half High Half Low", test_num);
            a = 16'hFF00;
            b = 16'h00FF;
            #1;

            check_outputs(16'h0000, 16'hFFFF, 16'hFFFF);
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
        input [15:0] expected_g;
        input [15:0] expected_p;
        input [15:0] expected_x;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_g === (expected_g ^ g ^ expected_g) &&
                expected_p === (expected_p ^ p ^ expected_p) &&
                expected_x === (expected_x ^ x ^ expected_x)) begin
                $display("PASS");
                $display("  Outputs: g=%h, p=%h, x=%h",
                         g, p, x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: g=%h, p=%h, x=%h",
                         expected_g, expected_p, expected_x);
                $display("  Got:      g=%h, p=%h, x=%h",
                         g, p, x);
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
