`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [1:0] ctrl;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .ctrl(ctrl),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Addition (0x1234 + 0x0001)", test_num);
            A = 16'h1234;
            B = 16'h0001;
            ctrl = 2'b00;
            #1;

            check_outputs(16'h1235);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Addition Overflow (0xFFFF + 0x0001)", test_num);
            A = 16'hFFFF;
            B = 16'h0001;
            ctrl = 2'b00;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Subtraction (0x0010 - 0x0001)", test_num);
            A = 16'h0010;
            B = 16'h0001;
            ctrl = 2'b01;
            #1;

            check_outputs(16'h000F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Subtraction Underflow (0x0000 - 0x0001)", test_num);
            A = 16'h0000;
            B = 16'h0001;
            ctrl = 2'b01;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Bitwise AND (0xAAAA & 0xF0F0)", test_num);
            A = 16'hAAAA;
            B = 16'hF0F0;
            ctrl = 2'b10;
            #1;

            check_outputs(16'hA0A0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Bitwise AND with Zero (0xFFFF & 0x0000)", test_num);
            A = 16'hFFFF;
            B = 16'h0000;
            ctrl = 2'b10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Bitwise OR (0x1234 | 0x4321)", test_num);
            A = 16'h1234;
            B = 16'h4321;
            ctrl = 2'b11;
            #1;

            check_outputs(16'h5335);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Bitwise OR with Full Mask (0x1234 | 0xFFFF)", test_num);
            A = 16'h1234;
            B = 16'hFFFF;
            ctrl = 2'b11;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Subtraction of Equal Values (0x1234 - 0x1234)", test_num);
            A = 16'h1234;
            B = 16'h1234;
            ctrl = 2'b01;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Addition of Zero (0xABCD + 0x0000)", test_num);
            A = 16'hABCD;
            B = 16'h0000;
            ctrl = 2'b00;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU Testbench");
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
        input [15:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
