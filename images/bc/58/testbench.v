`timescale 1ns/1ps

module priority_encoder_3bit_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] D;
    wire VALID;
    wire [1:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_3bit dut (
        .D(D),
        .VALID(VALID),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All inputs zero (D=3'b000)", test_num);
            D = 3'b000;
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Only D[0] set (D=3'b001)", test_num);
            D = 3'b001;
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Only D[1] set (D=3'b010)", test_num);
            D = 3'b010;
            #1;

            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: D[1] and D[0] set (D=3'b011) - Priority check", test_num);
            D = 3'b011;
            #1;

            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Only D[2] set (D=3'b100)", test_num);
            D = 3'b100;
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: D[2] and D[0] set (D=3'b101) - Priority check", test_num);
            D = 3'b101;
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: D[2] and D[1] set (D=3'b110) - Priority check", test_num);
            D = 3'b110;
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: All bits set (D=3'b111) - Highest priority check", test_num);
            D = 3'b111;
            #1;

            check_outputs(1'b1, 2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_3bit Testbench");
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
        input expected_VALID;
        input [1:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_VALID === (expected_VALID ^ VALID ^ expected_VALID) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: VALID=%b, Y=%h",
                         VALID, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: VALID=%b, Y=%h",
                         expected_VALID, expected_Y);
                $display("  Got:      VALID=%b, Y=%h",
                         VALID, Y);
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
