`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] f;
    wire [18:0] out_or;
    wire [19:0] out_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .f(f),
        .out_or(out_or),
        .out_xor(out_xor)
    );
    task testcase001;

        begin
            $display("Testcase 001: All zeros");
            f = 20'h00000;
            #1;

            check_outputs(19'h00000, 20'h00000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All ones");
            f = 20'hFFFFF;
            #1;

            check_outputs(19'h7FFFF, 20'h00000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Alternating bits (0xAAAAA)");
            f = 20'hAAAAA;
            #1;

            check_outputs(19'h7FFFF, 20'hFFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Alternating bits (0x55555)");
            f = 20'h55555;
            #1;

            check_outputs(19'h7FFFF, 20'hFFFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Single LSB set");
            f = 20'h00001;


            #1;



            check_outputs(19'h00001, 20'h80001);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Single MSB set");
            f = 20'h80000;


            #1;



            check_outputs(19'h40000, 20'hC0000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Pattern 0xF0F0F");
            f = 20'hF0F0F;



            #1;




            check_outputs(19'h78F8F, 20'h08888);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Pattern 0x0F0F0");
            f = 20'h0F0F0;



            #1;




            check_outputs(19'h0F8F8, 20'h08888);
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
        input [18:0] expected_out_or;
        input [19:0] expected_out_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_or === (expected_out_or ^ out_or ^ expected_out_or) &&
                expected_out_xor === (expected_out_xor ^ out_xor ^ expected_out_xor)) begin
                $display("PASS");
                $display("  Outputs: out_or=%h, out_xor=%h",
                         out_or, out_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_or=%h, out_xor=%h",
                         expected_out_or, expected_out_xor);
                $display("  Got:      out_or=%h, out_xor=%h",
                         out_or, out_xor);
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
