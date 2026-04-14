`timescale 1ns/1ps

module adder_subtractor_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg ctrl;
    wire overflow;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_subtractor dut (
        .A(A),
        .B(B),
        .ctrl(ctrl),
        .overflow(overflow),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Simple Addition (Positive + Positive)", test_num);
            A = 32'd100;
            B = 32'd200;
            ctrl = 1'b0;
            #1;

            check_outputs(1'b0, 32'd300);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Simple Subtraction (Positive - Positive)", test_num);
            A = 32'd500;
            B = 32'd100;
            ctrl = 1'b1;
            #1;

            check_outputs(1'b0, 32'd400);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Addition Resulting in Zero", test_num);
            A = 32'hFFFF_FFFF;
            B = 32'h0000_0001;
            ctrl = 1'b0;
            #1;

            check_outputs(1'b0, 32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Subtraction Resulting in Negative", test_num);
            A = 32'd10;
            B = 32'd20;
            ctrl = 1'b1;
            #1;

            check_outputs(1'b0, 32'hFFFF_FFF6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Positive Overflow Addition", test_num);
            A = 32'h7FFF_FFFF;
            B = 32'h0000_0001;
            ctrl = 1'b0;
            #1;

            check_outputs(1'b1, 32'h8000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Negative Overflow Addition", test_num);
            A = 32'h8000_0000;
            B = 32'hFFFF_FFFF;
            ctrl = 1'b0;
            #1;

            check_outputs(1'b1, 32'h7FFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Subtraction Positive Overflow", test_num);
            A = 32'h7FFF_FFFF;
            B = 32'hFFFF_FFFF;
            ctrl = 1'b1;
            #1;

            check_outputs(1'b1, 32'h8000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Subtraction Negative Overflow", test_num);
            A = 32'h8000_0000;
            B = 32'h0000_0001;
            ctrl = 1'b1;
            #1;

            check_outputs(1'b1, 32'h7FFF_FFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Subtraction of Equal Values", test_num);
            A = 32'h1234_5678;
            B = 32'h1234_5678;
            ctrl = 1'b1;
            #1;

            check_outputs(1'b0, 32'h0000_0000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Large Negative Addition (No Overflow)", test_num);
            A = 32'hC000_0000;
            B = 32'hC000_0000;
            ctrl = 1'b0;

            #1;


            check_outputs(1'b0, 32'h8000_0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_subtractor Testbench");
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
        input expected_overflow;
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, result=%h",
                         overflow, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, result=%h",
                         expected_overflow, expected_result);
                $display("  Got:      overflow=%b, result=%h",
                         overflow, result);
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
