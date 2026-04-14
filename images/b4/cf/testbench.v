`timescale 1ns/1ps

module priority_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [2:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Bit 0 set");
            in = 8'b00000001;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Bit 1 set");
            in = 8'b00000010;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Bit 2 set");
            in = 8'b00000100;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Bit 3 set");
            in = 8'b00001000;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Bit 4 set");
            in = 8'b00010000;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Bit 5 set");
            in = 8'b00100000;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Bit 6 set");
            in = 8'b01000000;
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Bit 7 set");
            in = 8'b10000000;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case 009: Multiple bits set (MSB Priority 7)");
            in = 8'b11111111;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case 010: Multiple bits set (MSB Priority 5)");
            in = 8'b00110101;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test Case 011: Pattern 01010101 (Priority 6)");
            in = 8'b01010101;
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test Case 012: Pattern 00000011 (Priority 1)");
            in = 8'b00000011;
            #1;

            check_outputs(3'd1);
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
        input [2:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
