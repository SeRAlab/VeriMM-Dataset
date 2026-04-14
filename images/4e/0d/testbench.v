`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [3:0] in;
    wire cout;
    wire lut4_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .in(in),
        .cout(cout),
        .lut4_out(lut4_out)
    );
    task test_step;

        input [3:0] i_in;
        input i_cin;
        input exp_cout;
        input exp_lut4_out;
        begin
            test_num = test_num + 1;
            in = i_in;
            cin = i_cin;
            #10;
            #1;

            check_outputs(exp_cout, exp_lut4_out);
        end
        endtask

    task testcase001;

    begin

        test_step(4'b0000, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin


        test_step(4'b1000, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin

        test_step(4'b0100, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin

        test_step(4'b1100, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin

        test_step(4'b0000, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin

        test_step(4'b1000, 1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin

        test_step(4'b0100, 1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin

        test_step(4'b1100, 1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase009;

    begin

        test_step(4'b1011, 1'b0, 1'b0, 1'b1);
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
        input expected_cout;
        input expected_lut4_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_lut4_out === (expected_lut4_out ^ lut4_out ^ expected_lut4_out)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, lut4_out=%b",
                         cout, lut4_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, lut4_out=%b",
                         expected_cout, expected_lut4_out);
                $display("  Got:      cout=%b, lut4_out=%b",
                         cout, lut4_out);
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
