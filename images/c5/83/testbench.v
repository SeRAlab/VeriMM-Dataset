`timescale 1ns/1ps

module comparator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire EQ;
    wire GT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator dut (
        .A(A),
        .B(B),
        .EQ(EQ),
        .GT(GT)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: A = 0, B = 0 (Expect EQ=1, GT=0)", test_num);
            A = 8'h00;
            B = 8'h00;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: A = 255, B = 255 (Expect EQ=1, GT=0)", test_num);
            A = 8'hFF;
            B = 8'hFF;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: A = 255, B = 0 (Expect EQ=0, GT=1)", test_num);
            A = 8'hFF;
            B = 8'h00;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: A = 0, B = 255 (Expect EQ=0, GT=0)", test_num);
            A = 8'h00;
            B = 8'hFF;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: A = 128, B = 127 (Expect EQ=0, GT=1)", test_num);
            A = 8'd128;
            B = 8'd127;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: A = 127, B = 128 (Expect EQ=0, GT=0)", test_num);
            A = 8'd127;
            B = 8'd128;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: A = 170, B = 170 (Expect EQ=1, GT=0)", test_num);
            A = 8'b10101010;
            B = 8'b10101010;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: A = 01010101, B = 01010100 (Expect EQ=0, GT=1)", test_num);
            A = 8'b01010101;
            B = 8'b01010100;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comparator Testbench");
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
        input expected_EQ;
        input expected_GT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EQ === (expected_EQ ^ EQ ^ expected_EQ) &&
                expected_GT === (expected_GT ^ GT ^ expected_GT)) begin
                $display("PASS");
                $display("  Outputs: EQ=%b, GT=%b",
                         EQ, GT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EQ=%b, GT=%b",
                         expected_EQ, expected_GT);
                $display("  Got:      EQ=%b, GT=%b",
                         EQ, GT);
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
