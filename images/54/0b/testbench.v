`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] B;
    reg [15:0] G;
    reg [15:0] R;
    wire [15:0] B_out;
    wire [15:0] G_out;
    wire [15:0] R_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B(B),
        .G(G),
        .R(R),
        .B_out(B_out),
        .G_out(G_out),
        .R_out(R_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Minimum Input Values (Black)", test_num);
        R = 16'h0000;
        G = 16'h0000;
        B = 16'h0000;


        #1;



        check_outputs(16'h0000, 16'h0000, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum Input Values (White)", test_num);
        R = 16'hFFFF;
        G = 16'hFFFF;
        B = 16'hFFFF;

        #1;


        check_outputs(16'hFFFF, 16'hFFFF, 16'hFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Pure Red", test_num);
        R = 16'hFFFF;
        G = 16'h0000;
        B = 16'h0000;
        #1;

        check_outputs(16'h0000, 16'h0000, 16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Pure Green", test_num);
        R = 16'h0000;
        G = 16'hFFFF;
        B = 16'h0000;
        #1;

        check_outputs(16'h0000, 16'hFFFF, 16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Pure Blue", test_num);
        R = 16'h0000;
        G = 16'h0000;
        B = 16'hFFFF;
        #1;

        check_outputs(16'hFFFF, 16'h0000, 16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mid-range Gray", test_num);
        R = 16'h8000;
        G = 16'h8000;
        B = 16'h8000;
        #1;

        check_outputs(16'h8000, 16'h8000, 16'h8000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random Color Mixture", test_num);
        R = 16'hA234;
        G = 16'h56B2;
        B = 16'h1F89;

        #1;


        check_outputs(16'h1F89, 16'h56B2, 16'hA234);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Low Values Near Threshold", test_num);
        R = 16'h0010;
        G = 16'h0010;
        B = 16'h0010;
        #1;

        check_outputs(16'h0010, 16'h0010, 16'h0010);
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
        input [15:0] expected_B_out;
        input [15:0] expected_G_out;
        input [15:0] expected_R_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_B_out === (expected_B_out ^ B_out ^ expected_B_out) &&
                expected_G_out === (expected_G_out ^ G_out ^ expected_G_out) &&
                expected_R_out === (expected_R_out ^ R_out ^ expected_R_out)) begin
                $display("PASS");
                $display("  Outputs: B_out=%h, G_out=%h, R_out=%h",
                         B_out, G_out, R_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B_out=%h, G_out=%h, R_out=%h",
                         expected_B_out, expected_G_out, expected_R_out);
                $display("  Got:      B_out=%h, G_out=%h, R_out=%h",
                         B_out, G_out, R_out);
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
