`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [30:0] i0;
    reg i1;
    wire [31:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i0(i0),
        .i1(i1),
        .o(o)
    );
    task testcase001;

        begin
            i1 = 1'b0;
            i0 = 31'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            i1 = 1'b1;
            i0 = 31'h7FFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            i1 = 1'b1;
            i0 = 31'h00000000;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase004;

        begin
            i1 = 1'b0;
            i0 = 31'h7FFFFFFF;
            #1;

            check_outputs(32'h7FFFFFFF);
        end
        endtask

    task testcase005;

        begin
            i1 = 1'b1;
            i0 = 31'h2AAAAAAA;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase006;

        begin
            i1 = 1'b0;
            i0 = 31'h55555555;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase007;

        begin
            i1 = 1'b1;
            i0 = 31'h12345678;
            #1;

            check_outputs(32'h92345678);
        end
        endtask

    task testcase008;

        begin
            i1 = 1'b0;
            i0 = 31'h0F0F0F0F;
            #1;

            check_outputs(32'h0F0F0F0F);
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
        testcase007();
        testcase008();
        
        
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
        input [31:0] expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
