`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] input_0;
    reg [31:0] input_1;
    reg selector;
    wire [31:0] write_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_0(input_0),
        .input_1(input_1),
        .selector(selector),
        .write_data(write_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            input_0 = 32'hCAFEBABE;
            input_1 = 32'hDEADBEEF;
            selector = 1'b0;
            $display("Test %0d: Select input_0 (selector=0)", test_num);
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            input_0 = 32'hCAFEBABE;
            input_1 = 32'hDEADBEEF;
            selector = 1'b1;
            $display("Test %0d: Select input_1 (selector=1)", test_num);
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            input_0 = 32'hFFFFFFFF;
            input_1 = 32'h00000000;
            selector = 1'b0;
            $display("Test %0d: Select input_0 (All 1s)", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            input_0 = 32'h00000000;
            input_1 = 32'hFFFFFFFF;
            selector = 1'b1;
            $display("Test %0d: Select input_1 (All 1s)", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            input_0 = 32'h12345678;
            input_1 = 32'h87654321;
            selector = 1'bx;
            $display("Test %0d: Invalid selector (expect default 0)", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            input_0 = 32'hAAAA5555;
            input_1 = 32'h5555AAAA;
            selector = 1'bz;
            $display("Test %0d: High-Z selector (expect default 0)", test_num);
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
        input [31:0] expected_write_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_write_data === (expected_write_data ^ write_data ^ expected_write_data)) begin
                $display("PASS");
                $display("  Outputs: write_data=%h",
                         write_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: write_data=%h",
                         expected_write_data);
                $display("  Got:      write_data=%h",
                         write_data);
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
