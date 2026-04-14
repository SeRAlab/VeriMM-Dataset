`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    reg [7:0] iv;
    reg [7:0] key;
    reg [1:0] mode;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .iv(iv),
        .key(key),
        .mode(mode),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Encryption Mode (mode=0)", test_num);
            in = 16'hABCD;
            key = 8'h55;
            iv = 8'h01;
            mode = 2'b00;


            #1;



            check_outputs(16'hABCD ^ {key, iv});
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Decryption Mode (mode=1)", test_num);
            in = 16'h1234;
            key = 8'hAA;
            iv = 8'h02;
            mode = 2'b01;

            #1;


            check_outputs(16'h1234 ^ {iv, key});
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Hash Mode (mode=2)", test_num);
            in = 16'hF0F0;
            key = 8'h00;
            iv = 8'h00;
            mode = 2'b10;

            #1;


            check_outputs(~16'hF0F0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros Input", test_num);
            in = 16'h0000;
            key = 8'h00;
            iv = 8'h00;
            mode = 2'b00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones Input/Key/IV", test_num);
            in = 16'hFFFF;
            key = 8'hFF;
            iv = 8'hFF;
            mode = 2'b00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits", test_num);
            in = 16'h5A5A;
            key = 8'hA5;
            iv = 8'h5A;
            mode = 2'b10;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mode Transition (Mode 0 -> 1)", test_num);
            in = 16'h1111;
            key = 8'h22;
            iv = 8'h33;

            mode = 2'b00;
            #5;
            mode = 2'b01;
            #1;

            check_outputs(16'h1111 ^ {iv, key});
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
