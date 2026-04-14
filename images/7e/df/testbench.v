`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] address;
    reg [15:0] pc_inc;
    wire [15:0] extended;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .pc_inc(pc_inc),
        .extended(extended)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        pc_inc = 16'h0000;
        address = 12'h000;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        pc_inc = 16'hE000;
        address = 12'h000;

        #1;


        check_outputs(16'hE000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        pc_inc = 16'h0000;
        address = 12'hFFF;

        #1;


        check_outputs(16'h1FFE);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        pc_inc = 16'hA000;
        address = 12'hAAA;


        #1;



        check_outputs(16'hB554);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        pc_inc = 16'h6000;
        address = 12'h555;


        #1;



        check_outputs(16'h6AAA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        pc_inc = 16'hFFFF;
        address = 12'h000;

        #1;


        check_outputs(16'hE000);
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
        input [15:0] expected_extended;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_extended === (expected_extended ^ extended ^ expected_extended)) begin
                $display("PASS");
                $display("  Outputs: extended=%h",
                         extended);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: extended=%h",
                         expected_extended);
                $display("  Got:      extended=%h",
                         extended);
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
