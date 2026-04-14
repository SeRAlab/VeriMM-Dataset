`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] readData2;
    reg [31:0] signExtend;
    reg sinalDoControleMux3;
    wire [31:0] saidaMux3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .readData2(readData2),
        .signExtend(signExtend),
        .sinalDoControleMux3(sinalDoControleMux3),
        .saidaMux3(saidaMux3)
    );
    task testcase001;

    begin
        test_num = 1;
        readData2 = 32'hABCD1234;
        signExtend = 32'h0000FFFF;
        sinalDoControleMux3 = 0;
        #1;

        check_outputs(32'hABCD1234);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        readData2 = 32'hABCD1234;
        signExtend = 32'hFFFF0000;
        sinalDoControleMux3 = 1;
        #1;

        check_outputs(32'hFFFF0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        readData2 = 32'h00000000;
        signExtend = 32'hFFFFFFFF;
        sinalDoControleMux3 = 0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        readData2 = 32'h00000000;
        signExtend = 32'hFFFFFFFF;
        sinalDoControleMux3 = 1;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        readData2 = 32'hAAAAAAAA;
        signExtend = 32'h55555555;
        sinalDoControleMux3 = 0;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        readData2 = 32'hAAAAAAAA;
        signExtend = 32'h55555555;
        sinalDoControleMux3 = 1;
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
        input [31:0] expected_saidaMux3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_saidaMux3 === (expected_saidaMux3 ^ saidaMux3 ^ expected_saidaMux3)) begin
                $display("PASS");
                $display("  Outputs: saidaMux3=%h",
                         saidaMux3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: saidaMux3=%h",
                         expected_saidaMux3);
                $display("  Got:      saidaMux3=%h",
                         saidaMux3);
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
