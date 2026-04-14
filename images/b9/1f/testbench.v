`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg [7:0] addr;
    wire [15:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .addr(addr),
        .data(data)
    );
    task testcase001;

        begin
            test_num = 1;
            addr = 8'h00;
            @(posedge CLK);
            #2;
            $display("Testcase %0d: Reading Address 0x00 (Expected 0xF104)", test_num);
            #1;

            check_outputs(16'hF104);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            addr = 8'h01;
            @(posedge CLK);
            #2;
            $display("Testcase %0d: Reading Address 0x01 (Expected 0xF100)", test_num);
            #1;

            check_outputs(16'hF100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            addr = 8'h02;
            @(posedge CLK);
            #2;
            $display("Testcase %0d: Reading Address 0x02 (Expected 0x0000)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            addr = 8'hFF;
            @(posedge CLK);
            #2;
            $display("Testcase %0d: Reading Address 0xFF (Expected 0x0000)", test_num);
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: data=%h",
                         data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h",
                         expected_data);
                $display("  Got:      data=%h",
                         data);
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
