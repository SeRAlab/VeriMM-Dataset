`timescale 1ns/1ps

module des_single_round_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data;
    reg [7:0] key;
    wire [7:0] cipher_text;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    des_single_round dut (
        .data(data),
        .key(key),
        .cipher_text(cipher_text)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Data=00, Key=00 (Zero Case)", test_num);
            data = 8'h00;
            key  = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Data=FF, Key=FF (All bits XOR to zero)", test_num);
            data = 8'hFF;
            key  = 8'hFF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Data=AA, Key=55 (Complementary patterns)", test_num);
            data = 8'hAA;
            key  = 8'h55;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Data=12, Key=00 (Identity)", test_num);
            data = 8'h12;
            key  = 8'h00;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Data=00, Key=FF (Inversion)", test_num);
            data = 8'h00;
            key  = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Data=A5, Key=3C (Random pattern)", test_num);
            data = 8'hA5;
            key  = 8'h3C;
            #1;

            check_outputs(8'h99);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Data=F0, Key=0F (Nibble Swap Effect)", test_num);
            data = 8'hF0;
            key  = 8'h0F;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Data=C3, Key=3C (Symmetric patterns)", test_num);
            data = 8'hC3;
            key  = 8'h3C;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("des_single_round Testbench");
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
        input [7:0] expected_cipher_text;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cipher_text === (expected_cipher_text ^ cipher_text ^ expected_cipher_text)) begin
                $display("PASS");
                $display("  Outputs: cipher_text=%h",
                         cipher_text);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cipher_text=%h",
                         expected_cipher_text);
                $display("  Got:      cipher_text=%h",
                         cipher_text);
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
