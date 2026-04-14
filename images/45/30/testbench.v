`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] G1;
    wire [31:0] Pr1;
    wire [31:0] g;
    wire [31:0] p;
    wire [31:0] x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .G1(G1),
        .Pr1(Pr1),
        .g(g),
        .p(p),
        .x(x)
    );
    task testcase001;

    begin
        run_test(32'h00000000, 32'h00000000);
    end
        endtask

    task testcase002;

    begin
        run_test(32'hFFFFFFFF, 32'hFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        run_test(32'hAAAAAAAA, 32'h55555555);
    end
        endtask

    task testcase004;

    begin
        run_test(32'h00000001, 32'h00000001);
    end
        endtask

    task testcase005;

    begin
        run_test(32'h00000003, 32'h00000000);
    end
        endtask

    task testcase006;

    begin
        run_test(32'h12345678, 32'h87654321);
    end
        endtask

    task testcase007;

    begin
        run_test(32'hDEADBEEF, 32'hCAFEBABE);
    end
        endtask

    task testcase008;

    begin
        run_test(32'hC0000000, 32'hC0000000);
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
        input [31:0] expected_G1;
        input [31:0] expected_Pr1;
        input [31:0] expected_g;
        input [31:0] expected_p;
        input [31:0] expected_x;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_G1 === (expected_G1 ^ G1 ^ expected_G1) &&
                expected_Pr1 === (expected_Pr1 ^ Pr1 ^ expected_Pr1) &&
                expected_g === (expected_g ^ g ^ expected_g) &&
                expected_p === (expected_p ^ p ^ expected_p) &&
                expected_x === (expected_x ^ x ^ expected_x)) begin
                $display("PASS");
                $display("  Outputs: G1=%h, Pr1=%h, g=%h, p=%h, x=%h",
                         G1, Pr1, g, p, x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: G1=%h, Pr1=%h, g=%h, p=%h, x=%h",
                         expected_G1, expected_Pr1, expected_g, expected_p, expected_x);
                $display("  Got:      G1=%h, Pr1=%h, g=%h, p=%h, x=%h",
                         G1, Pr1, g, p, x);
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
