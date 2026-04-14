`timescale 1ns/1ps

module binary_decoder_3to8_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] bin_in;
    wire [7:0] one_hot_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_decoder_3to8 dut (
        .bin_in(bin_in),
        .one_hot_out(one_hot_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: bin_in = 3'b000");
            bin_in = 3'b000;
            #1;

            check_outputs(8'b00000001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: bin_in = 3'b001");
            bin_in = 3'b001;
            #1;

            check_outputs(8'b00000010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: bin_in = 3'b010");
            bin_in = 3'b010;
            #1;

            check_outputs(8'b00000100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: bin_in = 3'b011");
            bin_in = 3'b011;
            #1;

            check_outputs(8'b00001000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: bin_in = 3'b100");
            bin_in = 3'b100;
            #1;

            check_outputs(8'b00010000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: bin_in = 3'b101");
            bin_in = 3'b101;
            #1;

            check_outputs(8'b00100000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: bin_in = 3'b110");
            bin_in = 3'b110;
            #1;

            check_outputs(8'b01000000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: bin_in = 3'b111");
            bin_in = 3'b111;
            #1;

            check_outputs(8'b10000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_decoder_3to8 Testbench");
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
        input [7:0] expected_one_hot_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_one_hot_out === (expected_one_hot_out ^ one_hot_out ^ expected_one_hot_out)) begin
                $display("PASS");
                $display("  Outputs: one_hot_out=%h",
                         one_hot_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: one_hot_out=%h",
                         expected_one_hot_out);
                $display("  Got:      one_hot_out=%h",
                         one_hot_out);
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
