`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg asel;
    reg [14:0] pc;
    reg [31:0] rs1;
    wire [31:0] alumux1_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .asel(asel),
        .pc(pc),
        .rs1(rs1),
        .alumux1_out(alumux1_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select rs1 (asel=0)", test_num);
        asel = 1'b0;
        pc  = 15'h1234;
        rs1 = 32'hAAAAAAAA;
        #10;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select pc (asel=1)", test_num);
        asel = 1'b1;
        pc  = 15'h5A5A;
        rs1 = 32'h12345678;
        #10;

        #1;


        check_outputs(32'h00005A5A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select rs1 with all ones (asel=0)", test_num);
        asel = 1'b0;
        pc  = 15'h0;
        rs1 = 32'hFFFFFFFF;
        #10;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select pc with max value (asel=1)", test_num);
        asel = 1'b1;
        pc  = 15'h7FFF;
        rs1 = 32'h0;
        #10;
        #1;

        check_outputs(32'h00007FFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select rs1 with zero (asel=0)", test_num);
        asel = 1'b0;
        pc  = 15'h7FFF;
        rs1 = 32'h00000000;
        #10;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Toggle asel from 0 to 1", test_num);
        pc  = 15'h0ABC;
        rs1 = 32'hCAFEFEED;
        asel = 1'b0;
        #5;
        asel = 1'b1;
        #10;
        #1;

        check_outputs(32'h00000ABC);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating bit pattern on rs1", test_num);
        asel = 1'b0;
        pc  = 15'h0;
        rs1 = 32'h55555555;
        #10;
        #1;

        check_outputs(32'h55555555);
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
        input [31:0] expected_alumux1_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_alumux1_out === (expected_alumux1_out ^ alumux1_out ^ expected_alumux1_out)) begin
                $display("PASS");
                $display("  Outputs: alumux1_out=%h",
                         alumux1_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alumux1_out=%h",
                         expected_alumux1_out);
                $display("  Got:      alumux1_out=%h",
                         alumux1_out);
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
