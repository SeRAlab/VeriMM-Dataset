`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    reg [3:0] sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All inputs zero", test_num);
            in = 16'h0000;
            sel = 4'h0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Inputs active, select inactive", test_num);
            in = 16'hFFFF;
            sel = 4'h0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select segment 0 (in[3:0])", test_num);
            in = 16'h0005;
            sel = 4'b0001;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select segment 1 (in[7:4])", test_num);
            in = 16'h00A0;
            sel = 4'b0010;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select segment 2 (in[11:8])", test_num);
            in = 16'h0F00;
            sel = 4'b0100;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Select segment 3 (in[15:12])", test_num);
            in = 16'h1000;
            sel = 4'b1000;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple selects (ORing segments 0 and 1)", test_num);

            in = 16'h00A5;
            sel = 4'b0011;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: All segments selected bitwise OR", test_num);

            in = 16'h8421;
            sel = 4'b1111;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data isolation - only selected segment passes", test_num);
            in = 16'hF0F0;
            sel = 4'b0100;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full input width toggle", test_num);
            in = 16'hAAAA;
            sel = 4'b1010;
            #1;

            check_outputs(4'hA);
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
        input [3:0] expected_out;
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
