`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A_i;
    wire [31:0] sigma_0_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A_i(A_i),
        .sigma_0_o(sigma_0_o)
    );
    task testcase001;

        begin
            test_num = 1;
            A_i = 32'h0000_0000;
            $display("Test %0d: All Zeros (A_i = %h)", test_num, A_i);
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A_i = 32'hFFFF_FFFF;
            $display("Test %0d: All Ones (A_i = %h)", test_num, A_i);
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A_i = 32'h0000_0001;
            $display("Test %0d: Single Bit (A_i = %h)", test_num, A_i);
            #1;

            check_outputs(32'h0040_2004);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A_i = 32'hAAAA_AAAA;
            $display("Test %0d: Alternating Bits (A_i = %h)", test_num, A_i);
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A_i = 32'h1234_5678;
            $display("Test %0d: Sequence (A_i = %h)", test_num, A_i);
            #1;

            check_outputs(32'h5E1B_DBBD);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A_i = 32'hDEAD_BEEF;
            $display("Test %0d: Complex (A_i = %h)", test_num, A_i);
            #1;

            check_outputs(32'h7676_AB6D);
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
        input [31:0] expected_sigma_0_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sigma_0_o === (expected_sigma_0_o ^ sigma_0_o ^ expected_sigma_0_o)) begin
                $display("PASS");
                $display("  Outputs: sigma_0_o=%h",
                         sigma_0_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sigma_0_o=%h",
                         expected_sigma_0_o);
                $display("  Got:      sigma_0_o=%h",
                         sigma_0_o);
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
