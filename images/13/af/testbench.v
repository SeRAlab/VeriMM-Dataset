`timescale 1ns/1ps

module rle_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg valid;
    wire done;
    wire [15:0] rle_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rle_encoder dut (
        .data_in(data_in),
        .valid(valid),
        .done(done),
        .rle_out(rle_out)
    );
    task reset_signals;

        begin
            data_in = 8'b0;
            valid = 1'b0;
            #10;
        end
        endtask

    task testcase001;

        begin
            reset_signals();
            $display("Running testcase001: All Zeros (8'b00000000)");
            data_in = 8'b00000000;
            valid = 1'b1;
            #1;

            check_outputs(1'b1, 16'hAAAA);
            valid = 1'b0;
        end
        endtask

    task testcase002;

        begin
            reset_signals();
            $display("Running testcase002: All Ones (8'b11111111)");
            data_in = 8'b11111111;
            valid = 1'b1;
            #1;

            check_outputs(1'b1, 16'hFFFF);
            valid = 1'b0;
        end
        endtask

    task testcase003;

        begin
            reset_signals();
            $display("Running testcase003: Alternating (8'b10101010)");
            data_in = 8'b10101010;
            valid = 1'b1;
            #1;

            check_outputs(1'b1, 16'hD5D5);
            valid = 1'b0;
        end
        endtask

    task testcase004;

        begin
            reset_signals();
            $display("Running testcase004: Mixed Blocks (8'b11110000)");
            data_in = 8'b11110000;
            valid = 1'b1;
            #1;

            check_outputs(1'b1, 16'hFFAA);
            valid = 1'b0;
        end
        endtask

    task testcase005;

        begin
            reset_signals();
            $display("Running testcase005: Single Bit Toggle (8'b00000001)");
            data_in = 8'b00000001;
            valid = 1'b1;
            #1;

            check_outputs(1'b1, 16'hAAAB);
            valid = 1'b0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rle_encoder Testbench");
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
        input expected_done;
        input [15:0] expected_rle_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_rle_out === (expected_rle_out ^ rle_out ^ expected_rle_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, rle_out=%h",
                         done, rle_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, rle_out=%h",
                         expected_done, expected_rle_out);
                $display("  Got:      done=%b, rle_out=%h",
                         done, rle_out);
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
