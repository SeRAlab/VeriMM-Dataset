`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 32'h00000000;
            b = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 32'hFFFFFFFF;
            b = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 32'hAAAAAAAA;
            b = 32'h55555555;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 32'h12345678;
            b = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 32'hDEADBEEF;
            b = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 32'hF0F0F0F0;
            b = 32'hFFFF0000;
            #1;

            check_outputs(32'hF0F00000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 32'h13579BDF;
            b = 32'h2468ACE0;





            #1;






            check_outputs(32'h004088C0);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
