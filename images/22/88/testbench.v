`timescale 1ns/1ps

module BitwiseAnd_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg enable;
    wire [7:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    BitwiseAnd dut (
        .A(A),
        .B(B),
        .enable(enable),
        .C(C)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Enable low, inputs high - C should be 0", test_num);
            enable = 0;
            A = 8'hFF;
            B = 8'hFF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Enable high, inputs zero - C should be 0", test_num);
            enable = 1;
            A = 8'h00;
            B = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Enable high, A=FF, B=FF - C should be FF", test_num);
            enable = 1;
            A = 8'hFF;
            B = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Enable high, bitwise non-overlapping patterns - C should be 0", test_num);
            enable = 1;
            A = 8'hAA;
            B = 8'h55;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Enable high, partial overlap (F0 & CC) - C should be C0", test_num);
            enable = 1;
            A = 8'hF0;
            B = 8'hCC;
            #1;

            check_outputs(8'hC0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Enable high, partial overlap (5A & 3C) - C should be 18", test_num);
            enable = 1;
            A = 8'h5A;
            B = 8'h3C;
            #1;

            check_outputs(8'h18);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Enable low, random inputs - C should be 0", test_num);
            enable = 0;
            A = 8'h12;
            B = 8'h34;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Enable high, A=DE, B=AD - C should be 8C", test_num);
            enable = 1;
            A = 8'hDE;
            B = 8'hAD;
            #1;

            check_outputs(8'h8C);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("BitwiseAnd Testbench");
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
        input [7:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
