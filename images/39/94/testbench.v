`timescale 1ns/1ps

module KoggeStoneAdder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    wire COUT;
    wire [4:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    KoggeStoneAdder dut (
        .A(A),
        .B(B),
        .COUT(COUT),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros (0 + 0)", test_num);
            A = 5'd0;
            B = 5'd0;
            #1;

            check_outputs(1'b0, 5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum value plus one (31 + 1)", test_num);
            A = 5'd31;
            B = 5'd1;
            #1;

            check_outputs(1'b1, 5'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-range Addition (15 + 16)", test_num);
            A = 5'd15;
            B = 5'd16;
            #1;

            check_outputs(1'b0, 5'd31);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full Carry Chain (31 + 31)", test_num);
            A = 5'h1F;
            B = 5'h1F;
            #1;

            check_outputs(1'b1, 5'h1E);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Addition 1 (10 + 5)", test_num);
            A = 5'd10;
            B = 5'd5;
            #1;

            check_outputs(1'b0, 5'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits (10 + 21)", test_num);
            A = 5'b01010;
            B = 5'b10101;
            #1;

            check_outputs(1'b0, 5'b11111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition resulting in Carry-Out (20 + 20)", test_num);
            A = 5'd20;
            B = 5'd20;
            #1;

            check_outputs(1'b1, 5'd8);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Power of 2 Addition (16 + 16)", test_num);
            A = 5'd16;
            B = 5'd16;
            #1;

            check_outputs(1'b1, 5'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Low bit carry (1 + 1)", test_num);
            A = 5'd1;
            B = 5'd1;
            #1;

            check_outputs(1'b0, 5'd2);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High bit addition (16 + 8)", test_num);
            A = 5'd16;
            B = 5'd8;
            #1;

            check_outputs(1'b0, 5'd24);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("KoggeStoneAdder Testbench");
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
        input expected_COUT;
        input [4:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, SUM=%h",
                         COUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, SUM=%h",
                         expected_COUT, expected_SUM);
                $display("  Got:      COUT=%b, SUM=%h",
                         COUT, SUM);
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
