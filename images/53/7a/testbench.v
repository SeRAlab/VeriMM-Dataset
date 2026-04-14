`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg carry_in;
    wire [31:0] adiv2;
    wire carry_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .carry_in(carry_in),
        .adiv2(adiv2),
        .carry_out(carry_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Even number, carry_in=0", test_num);
            a = 32'h0000_0002;
            carry_in = 1'b0;
            #1;

            check_outputs(32'h0000_0001, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Odd number, carry_in=0", test_num);
            a = 32'h0000_0003;
            carry_in = 1'b0;
            #1;

            check_outputs(32'h0000_0001, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Even number, carry_in=1", test_num);
            a = 32'h0000_0004;
            carry_in = 1'b1;
            #1;

            check_outputs(32'h8000_0002, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones, carry_in=0", test_num);
            a = 32'hFFFF_FFFF;
            carry_in = 1'b0;
            #1;

            check_outputs(32'h7FFF_FFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones, carry_in=1", test_num);
            a = 32'hFFFF_FFFF;
            carry_in = 1'b1;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits (A), carry_in=0", test_num);
            a = 32'hAAAA_AAAA;
            carry_in = 1'b0;
            #1;

            check_outputs(32'h5555_5555, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits (5), carry_in=1", test_num);
            a = 32'h5555_5555;
            carry_in = 1'b1;
            #1;

            check_outputs(32'hAAAA_AAAA, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB only, carry_in=0", test_num);
            a = 32'h8000_0000;
            carry_in = 1'b0;
            #1;

            check_outputs(32'h4000_0000, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros, carry_in=1", test_num);
            a = 32'h0000_0000;
            carry_in = 1'b1;
            #1;

            check_outputs(32'h8000_0000, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random pattern", test_num);
            a = 32'h1234_5678;
            carry_in = 1'b1;



            #1;




            check_outputs(32'h891A_2B3C, 1'b0);
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
        input [31:0] expected_adiv2;
        input expected_carry_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_adiv2 === (expected_adiv2 ^ adiv2 ^ expected_adiv2) &&
                expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out)) begin
                $display("PASS");
                $display("  Outputs: adiv2=%h, carry_out=%b",
                         adiv2, carry_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adiv2=%h, carry_out=%b",
                         expected_adiv2, expected_carry_out);
                $display("  Got:      adiv2=%h, carry_out=%b",
                         adiv2, carry_out);
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
