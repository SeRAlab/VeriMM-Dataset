`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    reg [63:0] sbox;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .sbox(sbox),
        .out(out)
    );
    task testcase001;

        integer i;
        begin
            $display("Testcase 001: Sequential Sweep with sbox=64'hFEDCBA9876543210");
            sbox = 64'hFEDCBA9876543210;
            for (i = 0; i < 16; i = i + 1) begin
                in = i;
                #1;
                #1;

                check_outputs(i[3:0]);
            end
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Check Boundary Nibbles (MSB and LSB)");
            sbox = 64'hA000000000000005;


            in = 4'h0;
            #1;
            #1;

            check_outputs(4'h5);


            in = 4'hF;
            #1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: All Zeros and All Ones");


            sbox = 64'hFFFFFFFFFFFFFFFF;
            in = 4'h7;
            #1;
            #1;

            check_outputs(4'hF);


            sbox = 64'h0000000000000000;
            in = 4'h3;
            #1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Alternating Pattern 0xA5A5...");
            sbox = 64'hA5A5A5A5A5A5A5A5;

            in = 4'h0;
            #1;
            #1;

            check_outputs(4'h5);

            in = 4'h1;
            #1;
            #1;

            check_outputs(4'hA);

            in = 4'hE;
            #1;
            #1;

            check_outputs(4'h5);

            in = 4'hF;
            #1;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Random-style S-box lookup");

            sbox = 64'h4E18D62B9F0C537A;

            in = 4'h0;
            #1;
            #1;

            check_outputs(4'hA);

            in = 4'h4;
            #1;
            #1;

            check_outputs(4'h5);

            in = 4'h7;
            #1;
            #1;

            check_outputs(4'h9);

            in = 4'hF;
            #1;
            #1;

            check_outputs(4'h4);
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
