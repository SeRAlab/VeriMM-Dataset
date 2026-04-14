`timescale 1ns/1ps

module priority_encoder_16_to_4_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] I;
    wire [3:0] Y;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_16_to_4 dut (
        .I(I),
        .Y(Y),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: No inputs active (Idle)", test_num);
        I = 16'h0000;
        #1;

        check_outputs(4'b1111, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bit 0 active", test_num);
        I = 16'h0001;
        #1;

        check_outputs(4'd0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bit 15 active", test_num);
        I = 16'h8000;
        #1;

        check_outputs(4'd15, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple inputs (0 and 1), expect bit 1", test_num);
        I = 16'h0003;
        #1;

        check_outputs(4'd1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple inputs (0 and 15), expect bit 15", test_num);
        I = 16'h8001;
        #1;

        check_outputs(4'd15, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single mid-range bit (7) active", test_num);
        I = 16'h0080;
        #1;

        check_outputs(4'd7, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple bits (4, 5, 10), expect bit 10", test_num);
        I = 16'h0430;
        #1;

        check_outputs(4'd10, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs active, expect bit 15", test_num);
        I = 16'hFFFF;
        #1;

        check_outputs(4'd15, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bits, high bit is 14", test_num);
        I = 16'h5555;
        #1;

        check_outputs(4'd14, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Highest bit is exactly bit 8", test_num);
        I = 16'h01FF;
        #1;

        check_outputs(4'd8, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_16_to_4 Testbench");
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
        input [3:0] expected_Y;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: Y=%h, valid=%b",
                         Y, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h, valid=%b",
                         expected_Y, expected_valid);
                $display("  Got:      Y=%h, valid=%b",
                         Y, valid);
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
