`timescale 1ns/1ps

module priority_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] I;
    wire [2:0] Y;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder dut (
        .I(I),
        .Y(Y),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: No inputs active", test_num);
        I = 8'b0000_0000;

        #1;


        check_outputs(3'b111, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Only I0 active (Highest Priority)", test_num);
        I = 8'b0000_0001;
        #1;

        check_outputs(3'b000, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Only I7 active (Lowest Priority)", test_num);
        I = 8'b1000_0000;
        #1;

        check_outputs(3'b111, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Only I4 active", test_num);
        I = 8'b0001_0000;
        #1;

        check_outputs(3'b100, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Multiple inputs (I0, I3, I7) active - I0 wins", test_num);
        I = 8'b1000_1001;
        #1;

        check_outputs(3'b000, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Multiple inputs (I1, I2, I5) active - I1 wins", test_num);
        I = 8'b0010_0110;
        #1;

        check_outputs(3'b001, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Multiple inputs (I6, I7) active - I6 wins", test_num);
        I = 8'b1100_0000;
        #1;

        check_outputs(3'b110, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: All inputs active - I0 wins", test_num);
        I = 8'b1111_1111;
        #1;

        check_outputs(3'b000, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Only I1 active", test_num);
        I = 8'b0000_0010;
        #1;

        check_outputs(3'b001, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Only I3 active", test_num);
        I = 8'b0000_1000;
        #1;

        check_outputs(3'b011, 1'b1);
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
        input [2:0] expected_Y;
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
