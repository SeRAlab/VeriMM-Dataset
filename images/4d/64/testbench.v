`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] qout;
    reg [31:0] qout_b;
    wire [63:0] nand_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .qout(qout),
        .qout_b(qout_b),
        .nand_out(nand_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            qout = 32'h00000000;
            qout_b = 32'h00000000;

            #1;


            check_outputs(~({qout, qout_b} & {qout_b, qout}));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            qout = 32'hFFFFFFFF;
            qout_b = 32'hFFFFFFFF;

            #1;


            check_outputs(~({qout, qout_b} & {qout_b, qout}));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            qout = 32'hAAAAAAAA;
            qout_b = 32'h55555555;

            #1;


            check_outputs(~({qout, qout_b} & {qout_b, qout}));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            qout = 32'hFFFF0000;
            qout_b = 32'h0000FFFF;

            #1;


            check_outputs(~({qout, qout_b} & {qout_b, qout}));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            qout = 32'h12345678;
            qout_b = 32'h87654321;

            #1;


            check_outputs(~({qout, qout_b} & {qout_b, qout}));
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            qout = 32'hF0F0F0F0;
            qout_b = 32'hF0F0F0F0;

            #1;


            check_outputs(~({qout, qout_b} & {qout_b, qout}));
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
        input [63:0] expected_nand_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_nand_out === (expected_nand_out ^ nand_out ^ expected_nand_out)) begin
                $display("PASS");
                $display("  Outputs: nand_out=%h",
                         nand_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nand_out=%h",
                         expected_nand_out);
                $display("  Got:      nand_out=%h",
                         nand_out);
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
