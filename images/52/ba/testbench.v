`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] crc;
    wire [31:0] b;
    wire [31:0] c;
    wire [31:0] d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .crc(crc),
        .b(b),
        .c(c),
        .d(d)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            crc = 32'h00000000;
            #10;

            #1;


            check_outputs(32'h0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            crc = 32'hFFFFFFFF;
            #10;

            #1;


            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits (1010...)", test_num);
            crc = 32'hAAAAAAAA;
            #10;

            #1;


            check_outputs(32'hAAAAAAAA, 32'hAAAAAAAA, 32'hAAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits (0101...)", test_num);
            crc = 32'h55555555;
            #10;

            #1;


            check_outputs(32'h55555555, 32'h55555555, 32'h55555555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Walking One (LSB)", test_num);
            crc = 32'h00000001;
            #10;

            #1;


            check_outputs(32'h00000001, 32'h00000001, 32'h00000001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Walking One (MSB)", test_num);
            crc = 32'h80000000;
            #10;

            #1;


            check_outputs(32'h80000000, 32'h80000000, 32'h80000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random Hex Pattern 1", test_num);
            crc = 32'h12345678;
            #10;

            #1;


            check_outputs(32'h12345678, 32'h12345678, 32'h12345678);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random Hex Pattern 2", test_num);
            crc = 32'hDEADBEEF;
            #10;

            #1;


            check_outputs(32'hDEADBEEF, 32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Symmetrical Pattern", test_num);
            crc = 32'hC3C3C3C3;
            #10;

            #1;


            check_outputs(32'hC3C3C3C3, 32'hC3C3C3C3, 32'hC3C3C3C3);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Prime-like Bit Distribution", test_num);
            crc = 32'hA5A5A5A5;
            #10;

            #1;


            check_outputs(32'hA5A5A5A5, 32'hA5A5A5A5, 32'hA5A5A5A5);
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
        input [31:0] expected_b;
        input [31:0] expected_c;
        input [31:0] expected_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b === (expected_b ^ b ^ expected_b) &&
                expected_c === (expected_c ^ c ^ expected_c) &&
                expected_d === (expected_d ^ d ^ expected_d)) begin
                $display("PASS");
                $display("  Outputs: b=%h, c=%h, d=%h",
                         b, c, d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%h, c=%h, d=%h",
                         expected_b, expected_c, expected_d);
                $display("  Got:      b=%h, c=%h, d=%h",
                         b, c, d);
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
