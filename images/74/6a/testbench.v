`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] in;
    wire [127:0] out;

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
            in = 128'h0;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = {4{32'hFFFFFFFF}};
            #1;

            check_outputs({4{32'hFFFFFFFF}});
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 128'h000000000000000000000000000000FF;
            #1;

            check_outputs(128'h00010001000100010001000100010001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 128'h01010101010101010101010101010101;
            #1;

            check_outputs(128'h0000000000000000000000000000FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = {4{32'h55555555}};
            #1;

            check_outputs(128'h0000FFFF0000FFFF0000FFFF0000FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 128'hFF00FF00FF00FF00FF00FF00FF00FF00;
            #1;

            check_outputs({4{32'h55555555}});
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
        input [127:0] expected_out;
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
