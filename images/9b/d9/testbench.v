`timescale 1ns/1ps

module priority_encoder_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    wire [1:0] binary_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_4bit dut (
        .in(in),
        .binary_out(binary_out),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: No inputs active", test_num);
        in = 4'b0000;
        #1;

        check_outputs(2'b00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bit 0 only", test_num);
        in = 4'b0001;
        #1;

        check_outputs(2'b00, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bit 1 only", test_num);
        in = 4'b0010;
        #1;

        check_outputs(2'b01, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bit 2 only", test_num);
        in = 4'b0100;
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bit 3 only (Highest Priority)", test_num);
        in = 4'b1000;
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bits 0 and 1 active (1 should win)", test_num);
        in = 4'b0011;
        #1;

        check_outputs(2'b01, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bits 1 and 2 active (2 should win)", test_num);
        in = 4'b0110;
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bits 0 and 3 active (3 should win)", test_num);
        in = 4'b1001;
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All bits active (3 should win)", test_num);
        in = 4'b1111;
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Bits 0, 1, 2 active (2 should win)", test_num);
        in = 4'b0111;
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
        input [1:0] expected_binary_out;
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
