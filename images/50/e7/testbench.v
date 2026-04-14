`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] addr;
    wire [31:0] eff_addr;
    wire [7:0] mod;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .eff_addr(eff_addr),
        .mod(mod)
    );
    task testcase001;

        begin
            test_num = 1;
            addr = 32'h00ABCDEF;

            #1;


            check_outputs(32'h00ABCDEF, 8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            addr = 32'h01ABCDEF;


            #1;



            check_outputs(32'h00001ABC, 8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            addr = 32'h02000FFF;

            #1;


            check_outputs(32'h00002000, 8'h03);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            addr = 32'hF0000000;

            #1;


            check_outputs(32'h000F0000, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            addr = 32'h00FFFFFF;

            #1;


            check_outputs(32'h00FFFFFF, 8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            addr = 32'hFFFFFFFF;

            #1;


            check_outputs(32'h000FFFFF, 8'h00);
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
        input [31:0] expected_eff_addr;
        input [7:0] expected_mod;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eff_addr === (expected_eff_addr ^ eff_addr ^ expected_eff_addr) &&
                expected_mod === (expected_mod ^ mod ^ expected_mod)) begin
                $display("PASS");
                $display("  Outputs: eff_addr=%h, mod=%h",
                         eff_addr, mod);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eff_addr=%h, mod=%h",
                         expected_eff_addr, expected_mod);
                $display("  Got:      eff_addr=%h, mod=%h",
                         eff_addr, mod);
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
