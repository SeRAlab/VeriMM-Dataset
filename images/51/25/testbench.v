`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in1;
    reg [31:0] in2;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero addition", test_num);
            in1 = 32'h0000_0000;
            in2 = 32'h0000_0000;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple small numbers", test_num);
            in1 = 32'h0000_0005;
            in2 = 32'h0000_000A;
            #1;

            check_outputs(32'h0000_000F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large numbers (No overflow)", test_num);
            in1 = 32'h1234_5678;
            in2 = 32'h1111_1111;
            #1;

            check_outputs(32'h2345_6789);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum value plus one (Overflow check)", test_num);
            in1 = 32'hFFFF_FFFF;
            in2 = 32'h0000_0001;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum value plus maximum value", test_num);
            in1 = 32'hFFFF_FFFF;
            in2 = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'hFFFF_FFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern addition 0xAAAA + 0x5555", test_num);
            in1 = 32'hAAAA_AAAA;
            in2 = 32'h5555_5555;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry propagation through middle bits", test_num);
            in1 = 32'h0000_FFFF;
            in2 = 32'h0000_0001;
            #1;

            check_outputs(32'h0001_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bitwise toggling values", test_num);
            in1 = 32'hF0F0_F0F0;
            in2 = 32'h0F0F_0F0F;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition resulting in signed negative (Two's complement check)", test_num);
            in1 = 32'h7000_0000;
            in2 = 32'h1000_0000;
            #1;

            check_outputs(32'h8000_0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random-like values", test_num);
            in1 = 32'hA5A5_5A5A;
            in2 = 32'h1234_5678;
            #1;

            check_outputs(32'hB7D9_B0D2);
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
