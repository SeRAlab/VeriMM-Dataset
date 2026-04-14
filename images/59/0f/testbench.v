`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] pcx_spc_grant_bufp1_pa_l;
    wire [4:0] pcx_spc_grant_bufpdl_pa;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pcx_spc_grant_bufp1_pa_l(pcx_spc_grant_bufp1_pa_l),
        .pcx_spc_grant_bufpdl_pa(pcx_spc_grant_bufpdl_pa)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All bits zero", test_num);
            pcx_spc_grant_bufp1_pa_l = 5'b00000;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: All bits one", test_num);
            pcx_spc_grant_bufp1_pa_l = 5'b11111;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Alternating bits (10101)", test_num);
            pcx_spc_grant_bufp1_pa_l = 5'b10101;
            #1;

            check_outputs(5'b01010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Alternating bits (01010)", test_num);
            pcx_spc_grant_bufp1_pa_l = 5'b01010;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Single bit set", test_num);
            pcx_spc_grant_bufp1_pa_l = 5'b00100;
            #1;

            check_outputs(5'b11011);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Boundary bit (MSB)", test_num);
            pcx_spc_grant_bufp1_pa_l = 5'b10000;
            #1;

            check_outputs(5'b01111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Boundary bit (LSB)", test_num);
            pcx_spc_grant_bufp1_pa_l = 5'b00001;
            #1;

            check_outputs(5'b11110);
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
        input [4:0] expected_pcx_spc_grant_bufpdl_pa;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pcx_spc_grant_bufpdl_pa === (expected_pcx_spc_grant_bufpdl_pa ^ pcx_spc_grant_bufpdl_pa ^ expected_pcx_spc_grant_bufpdl_pa)) begin
                $display("PASS");
                $display("  Outputs: pcx_spc_grant_bufpdl_pa=%h",
                         pcx_spc_grant_bufpdl_pa);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pcx_spc_grant_bufpdl_pa=%h",
                         expected_pcx_spc_grant_bufpdl_pa);
                $display("  Got:      pcx_spc_grant_bufpdl_pa=%h",
                         pcx_spc_grant_bufpdl_pa);
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
