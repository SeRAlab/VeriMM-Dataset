`timescale 1ns/1ps

module priority_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] data_in;
    wire [2:0] binary_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder dut (
        .data_in(data_in),
        .binary_out(binary_out),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No bits set", test_num);
            data_in = 5'b00000;
            #1;

            check_outputs(3'b000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit 0 only", test_num);
            data_in = 5'b00001;
            #1;

            check_outputs(3'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit 4 only (Highest bit)", test_num);
            data_in = 5'b10000;
            #1;

            check_outputs(3'd4, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit 4 and Bit 0 (Priority 4)", test_num);
            data_in = 5'b10001;
            #1;

            check_outputs(3'd4, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit 2, 1, and 0 (Priority 2)", test_num);
            data_in = 5'b00111;
            #1;

            check_outputs(3'd2, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All bits set (Priority 4)", test_num);
            data_in = 5'b11111;
            #1;

            check_outputs(3'd4, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit 3 and Bit 1 (Priority 3)", test_num);
            data_in = 5'b01010;
            #1;

            check_outputs(3'd3, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit 1 only", test_num);
            data_in = 5'b00010;
            #1;

            check_outputs(3'd1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit 3 and lower bits set", test_num);
            data_in = 5'b01111;
            #1;

            check_outputs(3'd3, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit 4 and 3 set", test_num);
            data_in = 5'b11000;
            #1;

            check_outputs(3'd4, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder Testbench");
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
        input [2:0] expected_binary_out;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_binary_out === (expected_binary_out ^ binary_out ^ expected_binary_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: binary_out=%h, valid=%b",
                         binary_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: binary_out=%h, valid=%b",
                         expected_binary_out, expected_valid);
                $display("  Got:      binary_out=%h, valid=%b",
                         binary_out, valid);
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
