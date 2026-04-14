`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg FlushPC;
    reg [31:0] PCplus4;
    reg [31:0] nPC;
    wire [31:0] F_nPC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .FlushPC(FlushPC),
        .PCplus4(PCplus4),
        .nPC(nPC),
        .F_nPC(F_nPC)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select PCplus4 (FlushPC=0)", test_num);
        FlushPC = 1'b0;
        PCplus4 = 32'hA5A5A5A5;
        nPC     = 32'h5A5A5A5A;
        #1;

        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select nPC (FlushPC=1)", test_num);
        FlushPC = 1'b1;
        PCplus4 = 32'hA5A5A5A5;
        nPC     = 32'h5A5A5A5A;
        #1;

        check_outputs(32'h5A5A5A5A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary - All Zeros (FlushPC=0)", test_num);
        FlushPC = 1'b0;
        PCplus4 = 32'h00000000;
        nPC     = 32'hFFFFFFFF;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary - All Ones (FlushPC=1)", test_num);
        FlushPC = 1'b1;
        PCplus4 = 32'h00000000;
        nPC     = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Specific Address Value (FlushPC=0)", test_num);
        FlushPC = 1'b0;
        PCplus4 = 32'h00000404;
        nPC     = 32'h00000800;
        #1;

        check_outputs(32'h00000404);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Specific Address Value (FlushPC=1)", test_num);
        FlushPC = 1'b1;
        PCplus4 = 32'h00000404;
        nPC     = 32'h00000800;
        #1;

        check_outputs(32'h00000800);
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
        input [31:0] expected_F_nPC;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_F_nPC === (expected_F_nPC ^ F_nPC ^ expected_F_nPC)) begin
                $display("PASS");
                $display("  Outputs: F_nPC=%h",
                         F_nPC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F_nPC=%h",
                         expected_F_nPC);
                $display("  Got:      F_nPC=%h",
                         F_nPC);
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
