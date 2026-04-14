`timescale 1ns/1ps

module xor_gate_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    xor_gate dut (
        .a(a),
        .b(b),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 16'h0000;
            b = 16'h0000;
            $display("Test Case %0d: All Zeros (0x0000 ^ 0x0000)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 16'hFFFF;
            b = 16'hFFFF;
            $display("Test Case %0d: All Ones (0xFFFF ^ 0xFFFF)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 16'hFFFF;
            b = 16'h0000;
            $display("Test Case %0d: Identity with Zero (0xFFFF ^ 0x0000)", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 16'hAAAA;
            b = 16'h5555;
            $display("Test Case %0d: Complement Patterns (0xAAAA ^ 0x5555)", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 16'h1234;
            b = 16'hABCD;
            $display("Test Case %0d: General Pattern 1 (0x1234 ^ 0xABCD)", test_num);
            #1;

            check_outputs(16'hB9F9);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 16'hF0F0;
            b = 16'h0F0F;
            $display("Test Case %0d: Nibble Swap Pattern (0xF0F0 ^ 0x0F0F)", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 16'h7FFF;
            b = 16'h8000;
            $display("Test Case %0d: MSB vs Others (0x7FFF ^ 0x8000)", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 16'h1111;
            b = 16'h2222;
            $display("Test Case %0d: Repeated Bits (0x1111 ^ 0x2222)", test_num);
            #1;

            check_outputs(16'h3333);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            a = 16'hCAFE;
            b = 16'hBABE;
            $display("Test Case %0d: Hex Words (0xCAFE ^ 0xBABE)", test_num);
            #1;

            check_outputs(16'h7040);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            a = 16'h1357;
            b = 16'hFFFF;
            $display("Test Case %0d: Bitwise Inversion (0x1357 ^ 0xFFFF)", test_num);
            #1;

            check_outputs(16'hECA8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("xor_gate Testbench");
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
        input [15:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
