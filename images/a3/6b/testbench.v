`timescale 1ns/1ps

module priority_encoder_5bit_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] data_in;
    wire [2:0] binary_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_5bit dut (
        .data_in(data_in),
        .binary_out(binary_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All inputs low", test_num);
            data_in = 5'b00000;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Only bit 0 high", test_num);
            data_in = 5'b00001;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Only bit 1 high", test_num);
            data_in = 5'b00010;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Only bit 2 high", test_num);
            data_in = 5'b00100;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Only bit 3 high", test_num);
            data_in = 5'b01000;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Only bit 4 high", test_num);
            data_in = 5'b10000;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Priority check - All bits high (Bit 4 priority)", test_num);
            data_in = 5'b11111;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Priority check - Bits 0, 1, 2, 3 high (Bit 3 priority)", test_num);
            data_in = 5'b01111;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Priority check - Bits 0, 1, 2 high (Bit 2 priority)", test_num);
            data_in = 5'b00111;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Priority check - Bits 0, 1 high (Bit 1 priority)", test_num);
            data_in = 5'b00011;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test %0d: Sparse bits high - Bits 4 and 0 high (Bit 4 priority)", test_num);
            data_in = 5'b10001;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test %0d: Sparse bits high - Bits 3 and 1 high (Bit 3 priority)", test_num);
            data_in = 5'b01010;
            #1;

            check_outputs(3'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_5bit Testbench");
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
        testcase011();
        testcase012();
        
        
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
        input [2:0] expected_binary_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_binary_out === (expected_binary_out ^ binary_out ^ expected_binary_out)) begin
                $display("PASS");
                $display("  Outputs: binary_out=%h",
                         binary_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: binary_out=%h",
                         expected_binary_out);
                $display("  Got:      binary_out=%h",
                         binary_out);
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
