`timescale 1ns/1ps

module decoder_4to16_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary_in;
    reg en;
    wire [15:0] decoded_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_4to16 dut (
        .binary_in(binary_in),
        .en(en),
        .decoded_out(decoded_out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Decoder Disabled (en=0)");
            en = 0;
            binary_in = 4'hA;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Enable High, Input 0 (decoded_out[0] should be 1)");
            en = 1;
            binary_in = 4'h0;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Enable High, Input 7 (decoded_out[7] should be 1)");
            en = 1;
            binary_in = 4'h7;
            #1;

            check_outputs(16'h0080);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enable High, Input 8 (decoded_out[8] should be 1)");
            en = 1;
            binary_in = 4'h8;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Enable High, Input 15 (decoded_out[15] should be 1)");
            en = 1;
            binary_in = 4'hF;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Re-disabling (en=0) with binary_in=4'hF");
            en = 0;
            binary_in = 4'hF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Enable High, Input 3 (decoded_out[3] should be 1)");
            en = 1;
            binary_in = 4'h3;
            #1;

            check_outputs(16'h0008);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_4to16 Testbench");
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
        input [15:0] expected_decoded_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decoded_out === (expected_decoded_out ^ decoded_out ^ expected_decoded_out)) begin
                $display("PASS");
                $display("  Outputs: decoded_out=%h",
                         decoded_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoded_out=%h",
                         expected_decoded_out);
                $display("  Got:      decoded_out=%h",
                         decoded_out);
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
