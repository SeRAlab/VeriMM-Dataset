`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] a;
    reg [4:0] b;
    reg [4:0] c;
    reg [4:0] d;
    reg [1:0] s;
    wire [4:0] r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .s(s),
        .r(r)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select input 'a' (s=00)", test_num);
            a = 5'h0A; b = 5'h0B; c = 5'h0C; d = 5'h0D;
            s = 2'b00;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select input 'b' (s=01)", test_num);
            a = 5'h0A; b = 5'h15; c = 5'h0C; d = 5'h0D;
            s = 2'b01;
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select input 'c' (s=10)", test_num);
            a = 5'h0A; b = 5'h0B; c = 5'h1F; d = 5'h0D;
            s = 2'b10;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select input 'd' (s=11)", test_num);
            a = 5'h01; b = 5'h02; c = 5'h03; d = 5'h04;
            s = 2'b11;
            #1;

            check_outputs(5'h04);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select input 'a' with distinct values", test_num);
            a = 5'h11; b = 5'h12; c = 5'h13; d = 5'h14;
            s = 2'b00;
            #1;

            check_outputs(5'h11);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select input 'b' with zero value", test_num);
            a = 5'h1F; b = 5'h00; c = 5'h1F; d = 5'h1F;
            s = 2'b01;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select input 'c' with max 5-bit value", test_num);
            a = 5'h00; b = 5'h00; c = 5'h1F; d = 5'h00;
            s = 2'b10;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Data transparency check for 'd'", test_num);
            a = 5'h05; b = 5'h05; c = 5'h05; d = 5'h1A;
            s = 2'b11;
            #1;

            check_outputs(5'h1A);
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
        input [4:0] expected_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: r=%h",
                         r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r=%h",
                         expected_r);
                $display("  Got:      r=%h",
                         r);
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
