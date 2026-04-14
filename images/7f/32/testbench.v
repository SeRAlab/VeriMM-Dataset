`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] amt;
    reg [1:0] ctrl;
    reg [31:0] in;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .amt(amt),
        .ctrl(ctrl),
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Logical Left Shift (ctrl=00, amt=3)", test_num);
            in = 32'h0000_0001;
            ctrl = 2'b00;
            amt = 3'd3;
            #1;

            check_outputs(32'h0000_0008);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Logical Left Shift Max (ctrl=00, amt=7)", test_num);
            in = 32'hFFFF_FFFF;
            ctrl = 2'b00;
            amt = 3'd7;
            #1;

            check_outputs(32'hFFFF_FF80);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Logical Right Shift (ctrl=01, amt=4)", test_num);
            in = 32'hF000_0000;
            ctrl = 2'b01;
            amt = 3'd4;
            #1;

            check_outputs(32'h0F00_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Logical Right Shift Zero (ctrl=01, amt=0)", test_num);
            in = 32'h1234_5678;
            ctrl = 2'b01;
            amt = 3'd0;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arithmetic Right Shift Positive (ctrl=10, amt=2)", test_num);
            in = 32'h4000_0000;
            ctrl = 2'b10;
            amt = 3'd2;
            #1;

            check_outputs(32'h1000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arithmetic Right Shift Negative (ctrl=10, amt=1)", test_num);
            in = 32'h8000_0000;
            ctrl = 2'b10;
            amt = 3'd1;
            #1;

            check_outputs(32'hC000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arithmetic Right Shift Max (ctrl=10, amt=7)", test_num);
            in = 32'hF000_0000;
            ctrl = 2'b10;
            amt = 3'd7;
            #1;

            check_outputs(32'hFE00_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Invalid Control Signal (ctrl=11)", test_num);
            in = 32'hFFFF_FFFF;
            ctrl = 2'b11;
            amt = 3'd5;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arithmetic Right Shift All Ones (ctrl=10, amt=7)", test_num);
            in = 32'hFFFF_FFFF;
            ctrl = 2'b10;
            amt = 3'd7;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Logical Left Shift Shift-in zeros (ctrl=00, amt=4)", test_num);
            in = 32'hAAAA_AAAA;
            ctrl = 2'b00;
            amt = 3'd4;
            #1;

            check_outputs(32'hAAAA_AA00 | 32'h0000_00A0);
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
