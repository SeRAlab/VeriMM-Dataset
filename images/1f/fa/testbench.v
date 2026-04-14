`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [1:0] control;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .control(control),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 16'h1234;
            B = 16'h1111;
            control = 2'b00;
            $display("Test Case %0d: Addition (1234 + 1111)", test_num);
            #1;

            check_outputs(16'h2345);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 16'hFFFF;
            B = 16'h0001;
            control = 2'b00;
            $display("Test Case %0d: Addition (FFFF + 0001)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 16'h000A;
            B = 16'h0005;
            control = 2'b01;
            $display("Test Case %0d: Subtraction (000A - 0005)", test_num);
            #1;

            check_outputs(16'h0005);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 16'h0000;
            B = 16'h0001;
            control = 2'b01;
            $display("Test Case %0d: Subtraction (0000 - 0001)", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 16'hAAAA;
            B = 16'h5555;
            control = 2'b10;
            $display("Test Case %0d: Bitwise AND (AAAA & 5555)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 16'hF0F0;
            B = 16'hFFFF;
            control = 2'b10;
            $display("Test Case %0d: Bitwise AND (F0F0 & FFFF)", test_num);
            #1;

            check_outputs(16'hF0F0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 16'hAAAA;
            B = 16'h5555;
            control = 2'b11;
            $display("Test Case %0d: Bitwise OR (AAAA | 5555)", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 16'h1234;
            B = 16'h0000;
            control = 2'b11;
            $display("Test Case %0d: Bitwise OR (1234 | 0000)", test_num);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 16'h0000;
            B = 16'h0000;
            control = 2'b00;
            $display("Test Case %0d: Boundary - All Zeros (ADD)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 16'hFFFF;
            B = 16'hFFFF;
            control = 2'b01;
            $display("Test Case %0d: Boundary - Same Values (SUB)", test_num);
            #1;

            check_outputs(16'h0000);
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
