`timescale 1ns/1ps

module binary_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] bin_in;
    reg en;
    wire [3:0] dec_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_decoder dut (
        .bin_in(bin_in),
        .en(en),
        .dec_out(dec_out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Disabled (en=0, bin_in=2'b00)");
            en = 0;
            bin_in = 2'b00;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Disabled (en=0, bin_in=2'b11)");
            en = 0;
            bin_in = 2'b11;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Enabled (en=1, bin_in=2'b00)");
            en = 1;
            bin_in = 2'b00;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enabled (en=1, bin_in=2'b01)");
            en = 1;
            bin_in = 2'b01;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Enabled (en=1, bin_in=2'b10)");
            en = 1;
            bin_in = 2'b10;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Enabled (en=1, bin_in=2'b11)");
            en = 1;
            bin_in = 2'b11;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_decoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [3:0] expected_dec_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dec_out === (expected_dec_out ^ dec_out ^ expected_dec_out)) begin
                $display("PASS");
                $display("  Outputs: dec_out=%h",
                         dec_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dec_out=%h",
                         expected_dec_out);
                $display("  Got:      dec_out=%h",
                         dec_out);
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
