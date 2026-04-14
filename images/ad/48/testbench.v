`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] datain0;
    reg [31:0] datain1;
    reg select;
    wire [31:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .datain0(datain0),
        .datain1(datain1),
        .select(select),
        .dataout(dataout)
    );
    task testcase001;

        begin
            test_num = 1;
            datain0 = 32'h12345678;
            datain1 = 32'h87654321;
            select = 1'b0;
            $display("Test %0d: Select datain0 (expected 12345678)", test_num);
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            datain0 = 32'h12345678;
            datain1 = 32'h87654321;
            select = 1'b1;
            $display("Test %0d: Select datain1 (expected 87654321)", test_num);
            #1;

            check_outputs(32'h87654321);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            datain0 = 32'h00000000;
            datain1 = 32'hFFFFFFFF;
            select = 1'b0;
            $display("Test %0d: Boundary Select 0 (expected 00000000)", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            datain0 = 32'h00000000;
            datain1 = 32'hFFFFFFFF;
            select = 1'b1;
            $display("Test %0d: Boundary Select 1 (expected FFFFFFFF)", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            datain0 = 32'hAAAAAAAA;
            datain1 = 32'h55555555;
            select = 1'b0;
            $display("Test %0d: Alternating Bits Select 0 (expected AAAAAAAA)", test_num);
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            datain0 = 32'hAAAAAAAA;
            datain1 = 32'h55555555;
            select = 1'b1;
            $display("Test %0d: Alternating Bits Select 1 (expected 55555555)", test_num);
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
        input [31:0] expected_dataout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h",
                         expected_dataout);
                $display("  Got:      dataout=%h",
                         dataout);
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
