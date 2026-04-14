`timescale 1ns/1ps

module encoder_8_to_3_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [2:0] out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    encoder_8_to_3 dut (
        .in(in),
        .out(out),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = 1;
        in = 8'b0000_0000;
        $display("Test Case 001: No inputs active (All zero)");
        #1;

        check_outputs(3'b000, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in = 8'b0000_0001;
        $display("Test Case 002: Only input 0 active");
        #1;

        check_outputs(3'd0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in = 8'b0000_0010;
        $display("Test Case 003: Only input 1 active");
        #1;

        check_outputs(3'd1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in = 8'b0000_0100;
        $display("Test Case 004: Only input 2 active");
        #1;

        check_outputs(3'd2, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in = 8'b0000_1000;
        $display("Test Case 005: Only input 3 active");
        #1;

        check_outputs(3'd3, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in = 8'b0001_0000;
        $display("Test Case 006: Only input 4 active");
        #1;

        check_outputs(3'd4, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in = 8'b0010_0000;
        $display("Test Case 007: Only input 5 active");
        #1;

        check_outputs(3'd5, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in = 8'b0100_0000;
        $display("Test Case 008: Only input 6 active");
        #1;

        check_outputs(3'd6, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in = 8'b1000_0000;
        $display("Test Case 009: Only input 7 active");
        #1;

        check_outputs(3'd7, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        in = 8'b0000_0011;
        $display("Test Case 010: Priority Check - Input 0 and 1 active (1 should win)");
        #1;

        check_outputs(3'd1, 1'b1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        in = 8'b0110_1000;
        $display("Test Case 011: Priority Check - Input 3, 5, and 6 active (6 should win)");
        #1;

        check_outputs(3'd6, 1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        in = 8'b1111_1111;
        $display("Test Case 012: Priority Check - All inputs active (7 should win)");
        #1;

        check_outputs(3'd7, 1'b1);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        in = 8'b1000_0001;
        $display("Test Case 013: Priority Check - Boundary inputs 0 and 7 active (7 should win)");
        #1;

        check_outputs(3'd7, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("encoder_8_to_3 Testbench");
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
        testcase013();
        
        
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
