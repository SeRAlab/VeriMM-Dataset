`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [99:0] in;
    wire [98:0] out_any;
    wire [98:0] out_both;
    wire [99:0] out_different;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out_any(out_any),
        .out_both(out_both),
        .out_different(out_different)
    );
    task testcase001;

        reg [99:0] val;
        begin
            test_num = test_num + 1;
            val = 100'h0;
            in = val;
            #1;

            check_outputs(val[99:1] | val[98:0], val[99:1] & val[98:0], val ^ {val[0], val[99:1]});
        end
        endtask

    task testcase002;

        reg [99:0] val;
        begin
            test_num = test_num + 1;
            val = {100{1'b1}};
            in = val;
            #1;

            check_outputs(val[99:1] | val[98:0], val[99:1] & val[98:0], val ^ {val[0], val[99:1]});
        end
        endtask

    task testcase003;

        reg [99:0] val;
        begin
            test_num = test_num + 1;
            val = {50{2'b10}};
            in = val;
            #1;

            check_outputs(val[99:1] | val[98:0], val[99:1] & val[98:0], val ^ {val[0], val[99:1]});
        end
        endtask

    task testcase004;

        reg [99:0] val;
        begin
            test_num = test_num + 1;
            val = {50{2'b01}};
            in = val;
            #1;

            check_outputs(val[99:1] | val[98:0], val[99:1] & val[98:0], val ^ {val[0], val[99:1]});
        end
        endtask

    task testcase005;

        reg [99:0] val;
        begin
            test_num = test_num + 1;
            val = 100'h1;
            in = val;
            #1;

            check_outputs(val[99:1] | val[98:0], val[99:1] & val[98:0], val ^ {val[0], val[99:1]});
        end
        endtask

    task testcase006;

        reg [99:0] val;
        begin
            test_num = test_num + 1;
            val = (100'h1 << 99);
            in = val;
            #1;

            check_outputs(val[99:1] | val[98:0], val[99:1] & val[98:0], val ^ {val[0], val[99:1]});
        end
        endtask

    task testcase007;

        reg [99:0] val;
        begin
            test_num = test_num + 1;
            val = 100'h7;
            in = val;
            #1;

            check_outputs(val[99:1] | val[98:0], val[99:1] & val[98:0], val ^ {val[0], val[99:1]});
        end
        endtask

    task testcase008;

        reg [99:0] val;
        begin
            test_num = test_num + 1;
            val = (100'h7 << 97);
            in = val;
            #1;

            check_outputs(val[99:1] | val[98:0], val[99:1] & val[98:0], val ^ {val[0], val[99:1]});
        end
        endtask

    task testcase009;

        reg [99:0] val;
        begin
            test_num = test_num + 1;
            val = (100'h1 << 99) | 100'h0;
            in = val;
            #1;

            check_outputs(val[99:1] | val[98:0], val[99:1] & val[98:0], val ^ {val[0], val[99:1]});
        end
        endtask

    task testcase010;

        reg [99:0] val;
        begin
            test_num = test_num + 1;
            val = 100'hA5A5A5A5A5A5A5A5A5A5A5A5A;
            in = val;
            #1;

            check_outputs(val[99:1] | val[98:0], val[99:1] & val[98:0], val ^ {val[0], val[99:1]});
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
        input [98:0] expected_out_any;
        input [98:0] expected_out_both;
        input [99:0] expected_out_different;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_any === (expected_out_any ^ out_any ^ expected_out_any) &&
                expected_out_both === (expected_out_both ^ out_both ^ expected_out_both) &&
                expected_out_different === (expected_out_different ^ out_different ^ expected_out_different)) begin
                $display("PASS");
                $display("  Outputs: out_any=%h, out_both=%h, out_different=%h",
                         out_any, out_both, out_different);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_any=%h, out_both=%h, out_different=%h",
                         expected_out_any, expected_out_both, expected_out_different);
                $display("  Got:      out_any=%h, out_both=%h, out_different=%h",
                         out_any, out_both, out_different);
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
