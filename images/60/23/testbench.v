`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] cmd;
    wire [3:0] addr_high;
    wire nop;
    wire [7:0] nrep;
    wire special;
    wire target_csr;
    wire target_nkmdprom;
    wire we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cmd(cmd),
        .addr_high(addr_high),
        .nop(nop),
        .nrep(nrep),
        .special(special),
        .target_csr(target_csr),
        .target_nkmdprom(target_nkmdprom),
        .we(we)
    );
    task testcase001;

        begin
            test_num = 1;
            cmd = 8'h00;

            #1;


            check_outputs(4'h0, 1'b1, 8'h00, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            cmd = 8'h45;


            #1;



            check_outputs(4'h4, 1'b0, 8'h45, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            cmd = 8'h2A;

            #1;


            check_outputs(4'h2, 1'b0, 8'h2A, 1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            cmd = 8'hF1;

            #1;


            check_outputs(4'hF, 1'b0, 8'hF1, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            cmd = 8'hFF;

            #1;


            check_outputs(4'hF, 1'b0, 8'hFF, 1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            cmd = 8'h55;
            #1;

            check_outputs(4'h5, 1'b0, 8'h55, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            cmd = 8'h80;
            #1;

            check_outputs(4'h8, 1'b0, 8'h80, 1'b0, 1'b0, 1'b0, 1'b1);
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
        input [3:0] expected_addr_high;
        input expected_nop;
        input [7:0] expected_nrep;
        input expected_special;
        input expected_target_csr;
        input expected_target_nkmdprom;
        input expected_we;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_addr_high === (expected_addr_high ^ addr_high ^ expected_addr_high) &&
                expected_nop === (expected_nop ^ nop ^ expected_nop) &&
                expected_nrep === (expected_nrep ^ nrep ^ expected_nrep) &&
                expected_special === (expected_special ^ special ^ expected_special) &&
                expected_target_csr === (expected_target_csr ^ target_csr ^ expected_target_csr) &&
                expected_target_nkmdprom === (expected_target_nkmdprom ^ target_nkmdprom ^ expected_target_nkmdprom) &&
                expected_we === (expected_we ^ we ^ expected_we)) begin
                $display("PASS");
                $display("  Outputs: addr_high=%h, nop=%b, nrep=%h, special=%b, target_csr=%b, target_nkmdprom=%b, we=%b",
                         addr_high, nop, nrep, special, target_csr, target_nkmdprom, we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr_high=%h, nop=%b, nrep=%h, special=%b, target_csr=%b, target_nkmdprom=%b, we=%b",
                         expected_addr_high, expected_nop, expected_nrep, expected_special, expected_target_csr, expected_target_nkmdprom, expected_we);
                $display("  Got:      addr_high=%h, nop=%b, nrep=%h, special=%b, target_csr=%b, target_nkmdprom=%b, we=%b",
                         addr_high, nop, nrep, special, target_csr, target_nkmdprom, we);
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
