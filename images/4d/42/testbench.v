`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg c_in;
    wire g_out;
    wire p_out;
    wire [3:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c_in(c_in),
        .g_out(g_out),
        .p_out(p_out),
        .s(s)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 8'h00; b = 8'h00; c_in = 0;
            #1;

            check_outputs(0, 0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 8'h00; b = 8'h00; c_in = 1;
            #1;

            check_outputs(0, 0, 8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 8'h12; b = 8'h34; c_in = 0;
            #1;

            check_outputs(0, 0, 8'h46);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 8'h0F; b = 8'hF0; c_in = 1;

            #1;


            check_outputs(0, 1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 8'h0F; b = 8'h01; c_in = 0;

            #1;


            check_outputs(0, 0, 8'h10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 8'h80; b = 8'h80; c_in = 0;

            #1;


            check_outputs(1, 0, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 8'hFF; b = 8'hFF; c_in = 1;

            #1;


            check_outputs(1, 1, 8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 8'hAA; b = 8'h55; c_in = 0;

            #1;


            check_outputs(0, 1, 8'hFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            a = 8'hF0; b = 8'h0F; c_in = 1;

            #1;


            check_outputs(0, 1, 8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            a = 8'hE0; b = 8'h20; c_in = 0;

            #1;


            check_outputs(1, 0, 8'h00);
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
        input expected_g_out;
        input expected_p_out;
        input [3:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_g_out === (expected_g_out ^ g_out ^ expected_g_out) &&
                expected_p_out === (expected_p_out ^ p_out ^ expected_p_out) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: g_out=%b, p_out=%b, s=%h",
                         g_out, p_out, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: g_out=%b, p_out=%b, s=%h",
                         expected_g_out, expected_p_out, expected_s);
                $display("  Got:      g_out=%b, p_out=%b, s=%h",
                         g_out, p_out, s);
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
