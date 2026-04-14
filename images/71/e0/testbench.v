`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    wire [7:0] d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest %0d: All Zeros", test_num);
            a = 8'h00;
            b = 8'h00;
            c = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest %0d: All Ones", test_num);
            a = 8'hFF;
            b = 8'hFF;
            c = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest %0d: No Overlapping Bits", test_num);
            a = 8'hF0;
            b = 8'h0F;
            c = 8'hAA;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest %0d: Bitwise Masking", test_num);
            a = 8'hF0;
            b = 8'hAA;
            c = 8'hCC;


            #1;



            check_outputs(8'h80);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest %0d: Only One Bit Common", test_num);
            a = 8'hFF;
            b = 8'h01;
            c = 8'h03;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest %0d: Alternating Bits", test_num);
            a = 8'h55;
            b = 8'h55;
            c = 8'h55;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest %0d: Complex Combination", test_num);
            a = 8'h77;
            b = 8'hBB;
            c = 8'hDD;


            #1;



            check_outputs(8'h11);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest %0d: One Input Zero Result", test_num);
            a = 8'hFF;
            b = 8'h00;
            c = 8'hFF;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d === (expected_d ^ d ^ expected_d)) begin
                $display("PASS");
                $display("  Outputs: d=%h",
                         d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d=%h",
                         expected_d);
                $display("  Got:      d=%h",
                         d);
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
