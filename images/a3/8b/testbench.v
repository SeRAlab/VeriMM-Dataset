`timescale 1ns/1ps

module priority_encoder_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [3:0] in;
    wire [1:0] out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder dut (
        .enable(enable),
        .in(in),
        .out(out),
        .valid(valid)
    );
    task testcase001;

        begin
            $display("Test 001: Enable signal low (Disabled state)");
            enable = 0;
            in = 4'b1111;
            #10;
            #1;

            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Test 002: Enable signal high, no inputs high");
            enable = 1;
            in = 4'b0000;
            #10;
            #1;

            check_outputs(2'b00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Test 003: Priority bit 0 (Only bit 0 high)");
            enable = 1;
            in = 4'b0001;
            #10;
            #1;

            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test 004: Priority bit 1 (Only bit 1 high)");
            enable = 1;
            in = 4'b0010;
            #10;
            #1;

            check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test 005: Priority bit 2 (Only bit 2 high)");
            enable = 1;
            in = 4'b0100;
            #10;
            #1;

            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Test 006: Priority bit 3 (Only bit 3 high)");
            enable = 1;
            in = 4'b1000;
            #10;
            #1;

            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Test 007: Multiple inputs - bit 3 vs bit 0 (Bit 3 priority)");
            enable = 1;
            in = 4'b1001;
            #10;
            #1;

            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Test 008: Multiple inputs - bit 2 vs bits 1,0 (Bit 2 priority)");
            enable = 1;
            in = 4'b0111;
            #10;
            #1;

            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase009;

        begin
            $display("Test 009: Multiple inputs - bit 1 vs bit 0 (Bit 1 priority)");
            enable = 1;
            in = 4'b0011;
            #10;
            #1;

            check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase010;

        begin
            $display("Test 010: All inputs high (Bit 3 should dominate)");
            enable = 1;
            in = 4'b1111;
            #10;
            #1;

            check_outputs(2'b11, 1'b1);
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
        input [1:0] expected_out;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: out=%h, valid=%b",
                         out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, valid=%b",
                         expected_out, expected_valid);
                $display("  Got:      out=%h, valid=%b",
                         out, valid);
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
