`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in;
    reg [3:0] vin;
    wire out;
    wire vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .vin(vin),
        .out(out),
        .vout(vout)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 1'b0;
            vin = 4'b0000;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 1'b1;
            vin = 4'b0000;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 1'b0;
            vin = 4'b0001;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 1'b1;
            vin = 4'b1000;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 1'b0;
            vin = 4'b1010;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 1'b1;
            vin = 4'b1111;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in = 1'b1;
            vin = 4'b0101;
            #1;

            check_outputs(1'b1, 1'b1);
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
        input expected_out;
        input expected_vout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_vout === (expected_vout ^ vout ^ expected_vout)) begin
                $display("PASS");
                $display("  Outputs: out=%b, vout=%b",
                         out, vout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, vout=%b",
                         expected_out, expected_vout);
                $display("  Got:      out=%b, vout=%b",
                         out, vout);
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
