`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] address;
    wire [7:0] pcAdderResult;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .pcAdderResult(pcAdderResult)
    );
    task testcase001;

        begin
            test_num = 1;
            address = 8'h00;
            $display("Testcase %03d: Input address = %h", test_num, address);
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            address = 8'h0A;
            $display("Testcase %03d: Input address = %h", test_num, address);
            #1;

            check_outputs(8'h0C);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            address = 8'h7F;
            $display("Testcase %03d: Input address = %h", test_num, address);
            #1;

            check_outputs(8'h81);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            address = 8'hFD;
            $display("Testcase %03d: Input address = %h", test_num, address);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            address = 8'hFE;
            $display("Testcase %03d: Input address = %h (Expect wrap-around)", test_num, address);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            address = 8'hFF;
            $display("Testcase %03d: Input address = %h (Expect wrap-around)", test_num, address);
            #1;

            check_outputs(8'h01);
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
        input [7:0] expected_pcAdderResult;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pcAdderResult === (expected_pcAdderResult ^ pcAdderResult ^ expected_pcAdderResult)) begin
                $display("PASS");
                $display("  Outputs: pcAdderResult=%h",
                         pcAdderResult);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pcAdderResult=%h",
                         expected_pcAdderResult);
                $display("  Got:      pcAdderResult=%h",
                         pcAdderResult);
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
