`timescale 1ns/1ps

module four_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CARRY_IN;
    wire CARRY_OUT;
    wire [4:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    four_bit_adder dut (
        .A(A),
        .B(B),
        .CARRY_IN(CARRY_IN),
        .CARRY_OUT(CARRY_OUT),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: A=0, B=0, CIN=0");
            A = 4'd0; B = 4'd0; CARRY_IN = 1'b0;
            #1;

            check_outputs(1'b0, 5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: A=15, B=15, CIN=1 (Max Input)");
            A = 4'd15; B = 4'd15; CARRY_IN = 1'b1;
            #1;

            check_outputs(1'b1, 5'd31);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: A=8, B=8, CIN=0");
            A = 4'd8; B = 4'd8; CARRY_IN = 1'b0;
            #1;

            check_outputs(1'b1, 5'd16);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: A=7, B=8, CIN=0");
            A = 4'd7; B = 4'd8; CARRY_IN = 1'b0;
            #1;

            check_outputs(1'b0, 5'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: A=7, B=8, CIN=1");
            A = 4'd7; B = 4'd8; CARRY_IN = 1'b1;
            #1;

            check_outputs(1'b1, 5'd16);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: A=5, B=3, CIN=0");
            A = 4'd5; B = 4'd3; CARRY_IN = 1'b0;
            #1;

            check_outputs(1'b0, 5'd8);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: A=12, B=10, CIN=0");
            A = 4'd12; B = 4'd10; CARRY_IN = 1'b0;
            #1;

            check_outputs(1'b1, 5'd22);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case 008: A=1, B=1, CIN=1");
            A = 4'd1; B = 4'd1; CARRY_IN = 1'b1;
            #1;

            check_outputs(1'b0, 5'd3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("four_bit_adder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_CARRY_OUT;
        input [4:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CARRY_OUT === (expected_CARRY_OUT ^ CARRY_OUT ^ expected_CARRY_OUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: CARRY_OUT=%b, SUM=%h",
                         CARRY_OUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CARRY_OUT=%b, SUM=%h",
                         expected_CARRY_OUT, expected_SUM);
                $display("  Got:      CARRY_OUT=%b, SUM=%h",
                         CARRY_OUT, SUM);
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
