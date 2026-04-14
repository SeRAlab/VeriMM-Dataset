`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] Rd;
    reg RegDst;
    reg [4:0] Rt;
    wire [4:0] RegAddr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Rd(Rd),
        .RegDst(RegDst),
        .Rt(Rt),
        .RegAddr(RegAddr)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select Rt (RegDst=0)", test_num);
        RegDst = 1'b0;
        Rt = 5'd10;
        Rd = 5'd20;

        #1;


        check_outputs(5'd10);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select Rd (RegDst=1)", test_num);
        RegDst = 1'b1;
        Rt = 5'd10;
        Rd = 5'd20;

        #1;


        check_outputs(5'd20);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary values (All ones)", test_num);
        RegDst = 1'b0;
        Rt = 5'b11111;
        Rd = 5'b00000;

        #1;


        check_outputs(5'b11111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary values (All zeros)", test_num);
        RegDst = 1'b1;
        Rt = 5'b11111;
        Rd = 5'b00000;

        #1;


        check_outputs(5'b00000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Pattern Test", test_num);
        RegDst = 1'b1;
        Rt = 5'b01010;
        Rd = 5'b10101;

        #1;


        check_outputs(5'b10101);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Switch selection mid-data", test_num);
        Rt = 5'd15;
        Rd = 5'd25;
        RegDst = 1'b0;
        #1;
        RegDst = 1'b1;

        #1;


        check_outputs(5'd25);
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
        input [4:0] expected_RegAddr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_RegAddr === (expected_RegAddr ^ RegAddr ^ expected_RegAddr)) begin
                $display("PASS");
                $display("  Outputs: RegAddr=%h",
                         RegAddr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RegAddr=%h",
                         expected_RegAddr);
                $display("  Got:      RegAddr=%h",
                         RegAddr);
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
