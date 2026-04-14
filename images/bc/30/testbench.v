`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] in;
    wire [63:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 64'h0000000000000000;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 64'h0000000000000001;
            #1;

            check_outputs(64'h0000000000000004);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 64'h0000000000000003;
            #1;

            check_outputs(64'h000000000000000C);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 64'hFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 64'h4000000000000000;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 64'hC000000000000000;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in = 64'h123456789ABCDEF0;
            #1;

            check_outputs(64'h48D159E26AF37BC0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in = 64'hAAAAAAAAAAAAAAAA;
            #1;

            check_outputs(64'hAAAAAAAAAAAAAAA8);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in = 64'h5555555555555555;
            #1;

            check_outputs(64'h5555555555555554);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in = 64'h0F0F0F0F0F0F0F0F;
            #1;

            check_outputs(64'h3C3C3C3C3C3C3C3C);
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
        testcase009();
        testcase010();
        
        
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
        input [63:0] expected_out;
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
