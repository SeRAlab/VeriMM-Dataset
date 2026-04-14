`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg [31:0] data;
    wire [31:0] piped_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .data(data),
        .piped_data(piped_data)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying basic data delay...", test_num);

        data = 32'h0;
        repeat(5) @(posedge CLK);


        data = 32'h12345678;

        repeat(10) @(posedge CLK);

        #1;


        check_outputs(32'h12345678);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying all-ones pattern...", test_num);

        data = 32'h0;
        repeat(5) @(posedge CLK);


        data = 32'hFFFFFFFF;
        repeat(10) @(posedge CLK);

        #1;


        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying alternating bits (0x5555AAAA)...", test_num);

        data = 32'h0;
        repeat(5) @(posedge CLK);


        data = 32'h5555AAAA;
        repeat(10) @(posedge CLK);

        #1;


        check_outputs(32'h5555AAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying clearing the pipeline with zeros...", test_num);

        data = 32'hDEADBEEF;
        repeat(10) @(posedge CLK);


        data = 32'h00000000;
        repeat(10) @(posedge CLK);

        #1;


        check_outputs(32'h00000000);
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
        input [31:0] expected_piped_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_piped_data === (expected_piped_data ^ piped_data ^ expected_piped_data)) begin
                $display("PASS");
                $display("  Outputs: piped_data=%h",
                         piped_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: piped_data=%h",
                         expected_piped_data);
                $display("  Got:      piped_data=%h",
                         piped_data);
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
