`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg icbne_i;
    reg [31:0] icconf_i;
    reg icov_i;
    wire [31:0] icconf_o;
    wire [2:0] icm_o;
    wire [1:0] ictmr_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .icbne_i(icbne_i),
        .icconf_i(icconf_i),
        .icov_i(icov_i),
        .icconf_o(icconf_o),
        .icm_o(icm_o),
        .ictmr_o(ictmr_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs zero", test_num);
            icconf_i = 32'h0000_0000;
            icov_i   = 1'b0;
            icbne_i  = 1'b0;

            #1;


            check_outputs(32'h0000_0000, 3'b000, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode field selection (bits 2:0)", test_num);
            icconf_i = 32'h0000_0005;
            icov_i   = 1'b0;
            icbne_i  = 1'b0;

            #1;


            check_outputs(32'h0000_0005, 3'b101, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Timer field selection (bits 9:8)", test_num);
            icconf_i = 32'h0000_0200;
            icov_i   = 1'b0;
            icbne_i  = 1'b0;

            #1;


            check_outputs(32'h0000_0200, 3'b000, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow flag integration (bit 15)", test_num);
            icconf_i = 32'h0000_0000;
            icov_i   = 1'b1;
            icbne_i  = 1'b0;

            #1;


            check_outputs(32'h0000_8000, 3'b000, 2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Break event integration (bit 14)", test_num);
            icconf_i = 32'h0000_0000;
            icov_i   = 1'b0;
            icbne_i  = 1'b1;

            #1;


            check_outputs(32'h0000_4000, 3'b000, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High-order bits preservation", test_num);
            icconf_i = 32'hABCD_0000;
            icov_i   = 1'b0;
            icbne_i  = 1'b0;

            #1;


            check_outputs(32'hABCD_0000, 3'b000, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex configuration mixed with flags", test_num);
            icconf_i = 32'h1234_0307;
            icov_i   = 1'b1;
            icbne_i  = 1'b1;

            #1;


            check_outputs(32'h1234_C307, 3'b111, 2'b11);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary condition - All ones", test_num);
            icconf_i = 32'hFFFF_FFFF;
            icov_i   = 1'b1;
            icbne_i  = 1'b1;

            #1;


            check_outputs(32'hFFFF_FFFF, 3'b111, 2'b11);
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
        input [31:0] expected_icconf_o;
        input [2:0] expected_icm_o;
        input [1:0] expected_ictmr_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_icconf_o === (expected_icconf_o ^ icconf_o ^ expected_icconf_o) &&
                expected_icm_o === (expected_icm_o ^ icm_o ^ expected_icm_o) &&
                expected_ictmr_o === (expected_ictmr_o ^ ictmr_o ^ expected_ictmr_o)) begin
                $display("PASS");
                $display("  Outputs: icconf_o=%h, icm_o=%h, ictmr_o=%h",
                         icconf_o, icm_o, ictmr_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: icconf_o=%h, icm_o=%h, ictmr_o=%h",
                         expected_icconf_o, expected_icm_o, expected_ictmr_o);
                $display("  Got:      icconf_o=%h, icm_o=%h, ictmr_o=%h",
                         icconf_o, icm_o, ictmr_o);
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
