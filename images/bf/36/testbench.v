`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ALUOutR;
    reg IDSel;
    reg [31:0] PC;
    wire [31:0] Adr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOutR(ALUOutR),
        .IDSel(IDSel),
        .PC(PC),
        .Adr(Adr)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select PC when IDSel is low", test_num);
            PC = 32'h12345678;
            ALUOutR = 32'hABCDEF00;
            IDSel = 0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Select ALUOutR when IDSel is high", test_num);
            PC = 32'h12345678;
            ALUOutR = 32'hABCDEF00;
            IDSel = 1;
            #1;

            check_outputs(32'hABCDEF00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary condition - Select PC (All zeros vs All ones)", test_num);
            PC = 32'h00000000;
            ALUOutR = 32'hFFFFFFFF;
            IDSel = 0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary condition - Select ALUOutR (All zeros vs All ones)", test_num);
            PC = 32'h00000000;
            ALUOutR = 32'hFFFFFFFF;
            IDSel = 1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random data pattern select PC", test_num);
            PC = 32'hA5A5A5A5;
            ALUOutR = 32'h5A5A5A5A;
            IDSel = 0;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random data pattern select ALUOutR", test_num);
            PC = 32'hA5A5A5A5;
            ALUOutR = 32'h5A5A5A5A;
            IDSel = 1;
            #1;

            check_outputs(32'h5A5A5A5A);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check switching IDSel while inputs stay constant", test_num);
            PC = 32'hDEADBEEF;
            ALUOutR = 32'hCAFEBABE;
            IDSel = 0;
            #10;
            IDSel = 1;
            #1;

            check_outputs(32'hCAFEBABE);
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
        input [31:0] expected_Adr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Adr === (expected_Adr ^ Adr ^ expected_Adr)) begin
                $display("PASS");
                $display("  Outputs: Adr=%h",
                         Adr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Adr=%h",
                         expected_Adr);
                $display("  Got:      Adr=%h",
                         Adr);
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
