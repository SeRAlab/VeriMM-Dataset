`timescale 1ns/1ps

module priority_encoder_6bit_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] data_in;
    wire [2:0] encoded_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_6bit dut (
        .data_in(data_in),
        .encoded_out(encoded_out),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All inputs zero", test_num);
            data_in = 6'b000000;
            #1;

            check_outputs(3'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: LSB only (Bit 0)", test_num);
            data_in = 6'b000001;
            #1;

            check_outputs(3'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bit 1 only", test_num);
            data_in = 6'b000010;
            #1;

            check_outputs(3'd1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bit 2 only", test_num);
            data_in = 6'b000100;
            #1;

            check_outputs(3'd2, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bit 3 only", test_num);
            data_in = 6'b001000;
            #1;

            check_outputs(3'd3, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bit 4 only", test_num);
            data_in = 6'b010000;
            #1;

            check_outputs(3'd4, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: MSB only (Bit 5)", test_num);
            data_in = 6'b100000;
            #1;

            check_outputs(3'd5, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority check - Bits 5 and 0 set", test_num);
            data_in = 6'b100001;
            #1;

            check_outputs(3'd5, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority check - Bits 3, 2, and 1 set", test_num);
            data_in = 6'b001110;
            #1;

            check_outputs(3'd3, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All bits set", test_num);
            data_in = 6'b111111;
            #1;

            check_outputs(3'd5, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_6bit Testbench");
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
        input [2:0] expected_encoded_out;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encoded_out === (expected_encoded_out ^ encoded_out ^ expected_encoded_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: encoded_out=%h, valid=%b",
                         encoded_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_out=%h, valid=%b",
                         expected_encoded_out, expected_valid);
                $display("  Got:      encoded_out=%h, valid=%b",
                         encoded_out, valid);
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
