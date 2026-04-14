`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg din_0;
    reg din_1;
    reg sel;
    wire mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din_0(din_0),
        .din_1(din_1),
        .sel(sel),
        .mux_out(mux_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: sel=0, din_0=0, din_1=0 -> Expected mux_out=0", test_num);
            din_0 = 0;
            din_1 = 0;
            sel   = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: sel=0, din_0=1, din_1=0 -> Expected mux_out=1", test_num);
            din_0 = 1;
            din_1 = 0;
            sel   = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: sel=0, din_0=0, din_1=1 -> Expected mux_out=0", test_num);
            din_0 = 0;
            din_1 = 1;
            sel   = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: sel=0, din_0=1, din_1=1 -> Expected mux_out=1", test_num);
            din_0 = 1;
            din_1 = 1;
            sel   = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: sel=1, din_0=0, din_1=0 -> Expected mux_out=0", test_num);
            din_0 = 0;
            din_1 = 0;
            sel   = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: sel=1, din_0=1, din_1=0 -> Expected mux_out=0", test_num);
            din_0 = 1;
            din_1 = 0;
            sel   = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: sel=1, din_0=0, din_1=1 -> Expected mux_out=1", test_num);
            din_0 = 0;
            din_1 = 1;
            sel   = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: sel=1, din_0=1, din_1=1 -> Expected mux_out=1", test_num);
            din_0 = 1;
            din_1 = 1;
            sel   = 1;
            #1;

            check_outputs(1);
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
        input expected_mux_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux_out === (expected_mux_out ^ mux_out ^ expected_mux_out)) begin
                $display("PASS");
                $display("  Outputs: mux_out=%b",
                         mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux_out=%b",
                         expected_mux_out);
                $display("  Got:      mux_out=%b",
                         mux_out);
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
