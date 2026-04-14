`timescale 1ns/1ps

module checksum_calculator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    wire [3:0] checksum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_calculator dut (
        .data_in(data_in),
        .checksum_out(checksum_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 1: All bits zero");
            data_in = 8'b0000_0000;
            #10;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 2: All bits one");
            data_in = 8'b1111_1111;
            #10;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 3: Single bit LSB");
            data_in = 8'b0000_0001;
            #10;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 4: Single bit MSB");
            data_in = 8'b1000_0000;
            #10;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 5: Alternating bits (0xAA)");
            data_in = 8'hAA;
            #10;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 6: Alternating bits (0x55)");
            data_in = 8'h55;
            #10;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 7: High nibble all ones");
            data_in = 8'hF0;
            #10;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 8: Low nibble all ones");
            data_in = 8'h0F;
            #10;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case 9: Random pattern (0xBD)");
            data_in = 8'b1011_1101;
            #10;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case 10: Seven bits set");
            data_in = 8'b0111_1111;
            #10;
            #1;

            check_outputs(4'd7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum_calculator Testbench");
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
        input [3:0] expected_checksum_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h",
                         checksum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h",
                         expected_checksum_out);
                $display("  Got:      checksum_out=%h",
                         checksum_out);
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
