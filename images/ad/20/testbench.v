`timescale 1ns/1ps

module binary_decoder_2to4_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] binary_in;
    wire [3:0] decoder_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_decoder_2to4 dut (
        .binary_in(binary_in),
        .decoder_out(decoder_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: binary_in = 00", test_num);
            binary_in = 2'b00;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: binary_in = 01", test_num);
            binary_in = 2'b01;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: binary_in = 10", test_num);
            binary_in = 2'b10;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: binary_in = 11", test_num);
            binary_in = 2'b11;
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
        $display("binary_decoder_2to4 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [3:0] expected_decoder_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decoder_out === (expected_decoder_out ^ decoder_out ^ expected_decoder_out)) begin
                $display("PASS");
                $display("  Outputs: decoder_out=%h",
                         decoder_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decoder_out=%h",
                         expected_decoder_out);
                $display("  Got:      decoder_out=%h",
                         decoder_out);
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
