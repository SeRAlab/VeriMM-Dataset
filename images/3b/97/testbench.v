`timescale 1ns/1ps

module encoder_4_to_2_tb;

    // Testbench signals (combinational circuit)
    reg I0;
    reg I1;
    reg I2;
    reg I3;
    wire [1:0] O;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    encoder_4_to_2 dut (
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .O(O),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: No inputs active (I=0000)", test_num);
        I3 = 0; I2 = 0; I1 = 0; I0 = 0;
        #1;

        check_outputs(2'bxx, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Only I0 active (I=0001)", test_num);
        I3 = 0; I2 = 0; I1 = 0; I0 = 1;
        #1;

        check_outputs(2'b00, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Only I1 active (I=0010)", test_num);
        I3 = 0; I2 = 0; I1 = 1; I0 = 0;
        #1;

        check_outputs(2'b01, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Only I2 active (I=0100)", test_num);
        I3 = 0; I2 = 1; I1 = 0; I0 = 0;
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Only I3 active (I=1000)", test_num);
        I3 = 1; I2 = 0; I1 = 0; I0 = 0;
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Multiple inputs (I3 and I0), I3 priority (I=1001)", test_num);
        I3 = 1; I2 = 0; I1 = 0; I0 = 1;
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Multiple inputs (I2 and I1), I2 priority (I=0110)", test_num);
        I3 = 0; I2 = 1; I1 = 1; I0 = 0;
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Multiple inputs (I1 and I0), I1 priority (I=0011)", test_num);
        I3 = 0; I2 = 0; I1 = 1; I0 = 1;
        #1;

        check_outputs(2'b01, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: All inputs active, I3 priority (I=1111)", test_num);
        I3 = 1; I2 = 1; I1 = 1; I0 = 1;
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: I2, I1, I0 active, I2 priority (I=0111)", test_num);
        I3 = 0; I2 = 1; I1 = 1; I0 = 1;
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
        $display("encoder_4_to_2 Testbench");
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
        input [1:0] expected_O;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: O=%h, valid=%b",
                         O, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h, valid=%b",
                         expected_O, expected_valid);
                $display("  Got:      O=%h, valid=%b",
                         O, valid);
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
