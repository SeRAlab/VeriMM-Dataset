`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [3:0] in;
    wire [15:0] out;
    wire [15:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .in(in),
        .out(out),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 16'h0005;
        B = 16'h000A;
        in = 4'h0;

        #1;


        check_outputs(16'hFFFE, 16'h000F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 16'h8005;
        B = 16'h800A;
        in = 4'h1;

        #1;


        check_outputs(16'hFFFD, 16'h800F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 16'h0014;
        B = 16'h8005;
        in = 4'h4;

        #1;


        check_outputs(16'hFFEF, 16'h000F);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 16'h0005;
        B = 16'h8014;
        in = 4'h8;

        #1;


        check_outputs(16'hFEFF, 16'h800F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 16'h000A;
        B = 16'h800A;
        in = 4'hF;

        #1;


        check_outputs(16'h7FFF, 16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 16'h7FFF;
        B = 16'h0000;
        in = 4'h2;

        #1;


        check_outputs(16'hFFFB, 16'h7FFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 16'h8000;
        B = 16'h8001;
        in = 4'h3;

        #1;


        check_outputs(16'hFFF7, 16'h8001);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 16'hFFFF;
        B = 16'h7FFF;
        in = 4'h5;

        #1;


        check_outputs(16'hFFDF, 16'h0000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 16'h0064;
        B = 16'h0064;
        in = 4'h7;

        #1;


        check_outputs(16'hFF7F, 16'h00C8);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 16'h8064;
        B = 16'h0032;
        in = 4'hE;

        #1;


        check_outputs(16'hBFFF, 16'h8032);
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
        input [15:0] expected_out;
        input [15:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: out=%h, sum=%h",
                         out, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, sum=%h",
                         expected_out, expected_sum);
                $display("  Got:      out=%h, sum=%h",
                         out, sum);
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
