`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] pcx_spc_grant_bufp3_pa_l;
    wire [4:0] pcx_spc_grant_bufpdr_pa;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pcx_spc_grant_bufp3_pa_l(pcx_spc_grant_bufp3_pa_l),
        .pcx_spc_grant_bufpdr_pa(pcx_spc_grant_bufpdr_pa)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: All zeros input");
        pcx_spc_grant_bufp3_pa_l = 5'b00000;
        #1;

        check_outputs(5'b11111);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: All ones input");
        pcx_spc_grant_bufp3_pa_l = 5'b11111;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Alternating pattern 10101");
        pcx_spc_grant_bufp3_pa_l = 5'b10101;
        #1;

        check_outputs(5'b01010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Alternating pattern 01010");
        pcx_spc_grant_bufp3_pa_l = 5'b01010;
        #1;

        check_outputs(5'b10101);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Single bit high (LSB)");
        pcx_spc_grant_bufp3_pa_l = 5'b00001;
        #1;

        check_outputs(5'b11110);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Single bit high (MSB)");
        pcx_spc_grant_bufp3_pa_l = 5'b10000;
        #1;

        check_outputs(5'b01111);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Random pattern 11001");
        pcx_spc_grant_bufp3_pa_l = 5'b11001;
        #1;

        check_outputs(5'b00110);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase 008: Random pattern 00110");
        pcx_spc_grant_bufp3_pa_l = 5'b00110;
        #1;

        check_outputs(5'b11001);
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
        input [4:0] expected_pcx_spc_grant_bufpdr_pa;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pcx_spc_grant_bufpdr_pa === (expected_pcx_spc_grant_bufpdr_pa ^ pcx_spc_grant_bufpdr_pa ^ expected_pcx_spc_grant_bufpdr_pa)) begin
                $display("PASS");
                $display("  Outputs: pcx_spc_grant_bufpdr_pa=%h",
                         pcx_spc_grant_bufpdr_pa);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pcx_spc_grant_bufpdr_pa=%h",
                         expected_pcx_spc_grant_bufpdr_pa);
                $display("  Got:      pcx_spc_grant_bufpdr_pa=%h",
                         pcx_spc_grant_bufpdr_pa);
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
