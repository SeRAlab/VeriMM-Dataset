`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] inst;
    reg [31:0] nextPc;
    wire [31:0] jumpPc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inst(inst),
        .nextPc(nextPc),
        .jumpPc(jumpPc)
    );
    task testcase001;

    begin
        test_num = 1;
        nextPc = 32'h0000_0000;
        inst   = 32'h0000_0000;

        #1;


        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        nextPc = 32'hFFFF_FFFF;
        inst   = 32'hFFFF_FFFF;


        #1;



        check_outputs(32'hFFFF_FFFC);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        nextPc = 32'hA000_0000;
        inst   = 32'h0000_0000;

        #1;


        check_outputs(32'hA000_0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        nextPc = 32'h0000_0000;
        inst   = 32'h0000_0001;


        #1;



        check_outputs(32'h0000_0004);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        nextPc = 32'h0000_0000;
        inst   = 32'hFC00_0000;

        #1;


        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        nextPc = 32'h5000_0000;
        inst   = 32'h02AA_AAAA;


        #1;



        check_outputs(32'h5AAA_AAA8);
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
        input [31:0] expected_jumpPc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_jumpPc === (expected_jumpPc ^ jumpPc ^ expected_jumpPc)) begin
                $display("PASS");
                $display("  Outputs: jumpPc=%h",
                         jumpPc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: jumpPc=%h",
                         expected_jumpPc);
                $display("  Got:      jumpPc=%h",
                         jumpPc);
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
