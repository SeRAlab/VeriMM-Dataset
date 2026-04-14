`timescale 1ns/1ps

module priority_encoder_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] IN;
    wire [1:0] OUT;
    wire VALID;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_4bit dut (
        .IN(IN),
        .OUT(OUT),
        .VALID(VALID)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: IN = 4'b0000 (No input active)");
        IN = 4'b0000;

        #1;


        check_outputs(2'b00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: IN = 4'b0001 (Bit 0 active)");
        IN = 4'b0001;
        #1;

        check_outputs(2'b00, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: IN = 4'b0010 (Bit 1 active)");
        IN = 4'b0010;
        #1;

        check_outputs(2'b01, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: IN = 4'b0100 (Bit 2 active)");
        IN = 4'b0100;
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: IN = 4'b1000 (Bit 3 active)");
        IN = 4'b1000;
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: IN = 4'b0011 (Priority to Bit 1)");
        IN = 4'b0011;
        #1;

        check_outputs(2'b01, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: IN = 4'b0110 (Priority to Bit 2)");
        IN = 4'b0110;
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: IN = 4'b1101 (Priority to Bit 3)");
        IN = 4'b1101;
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: IN = 4'b1111 (All bits active, Priority to Bit 3)");
        IN = 4'b1111;
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: IN = 4'b0101 (Priority to Bit 2)");
        IN = 4'b0101;
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_4bit Testbench");
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
        input [1:0] expected_OUT;
        input expected_VALID;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT) &&
                expected_VALID === (expected_VALID ^ VALID ^ expected_VALID)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h, VALID=%b",
                         OUT, VALID);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h, VALID=%b",
                         expected_OUT, expected_VALID);
                $display("  Got:      OUT=%h, VALID=%b",
                         OUT, VALID);
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
