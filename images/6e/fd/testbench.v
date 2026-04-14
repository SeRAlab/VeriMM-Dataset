`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] known_in;
    reg [7:0] rx_in;
    wire [3:0] decoded_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .known_in(known_in),
        .rx_in(rx_in),
        .decoded_out(decoded_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros decoding", test_num);
            known_in = 4'b0000;
            rx_in = 8'b00000000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones decoding", test_num);
            known_in = 4'b1111;
            rx_in = 8'b11111111;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bit pattern 1010", test_num);
            known_in = 4'b1010;
            rx_in = 8'b10101010;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bit pattern 0101", test_num);
            known_in = 4'b0101;
            rx_in = 8'b01010101;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit high (MSB)", test_num);
            known_in = 4'b1000;
            rx_in = 8'b11000000;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit high (LSB)", test_num);
            known_in = 4'b0001;
            rx_in = 8'b00000011;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-range pattern 0110", test_num);
            known_in = 4'b0110;
            rx_in = 8'b00111100;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Error Correction Test (Single Bit Flip)", test_num);
            known_in = 4'b1111;

            rx_in = 8'b11110111;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Error Correction Test (Alternate Bits)", test_num);
            known_in = 4'b0000;

            rx_in = 8'b00000010;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex bit pattern 1101", test_num);
            known_in = 4'b1101;
            rx_in = 8'b11110011;
            #1;

            check_outputs(4'b1101);
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
        input [3:0] expected_decoded_out;
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
