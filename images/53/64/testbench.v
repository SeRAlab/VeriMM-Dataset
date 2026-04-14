`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    wire [2:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 8'b00000001;
        $display("Test %0d: Input A = %b (Pattern 0)", test_num, A);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 8'b00000010;
        $display("Test %0d: Input A = %b (Pattern 1)", test_num, A);
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 8'b00000100;
        $display("Test %0d: Input A = %b (Pattern 2)", test_num, A);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 8'b00001000;
        $display("Test %0d: Input A = %b (Pattern 3)", test_num, A);
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 8'b00010000;
        $display("Test %0d: Input A = %b (Pattern 4)", test_num, A);
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 8'b00100000;
        $display("Test %0d: Input A = %b (Pattern 5)", test_num, A);
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 8'b01000000;
        $display("Test %0d: Input A = %b (Pattern 6)", test_num, A);
        #1;

        check_outputs(3'b110);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 8'b10000000;
        $display("Test %0d: Input A = %b (Pattern 7)", test_num, A);
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 8'b00000000;
        $display("Test %0d: Input A = %b (Zero input - expect undefined)", test_num, A);
        #1;

        check_outputs(3'bxxx);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 8'b00000011;
        $display("Test %0d: Input A = %b (Multiple bits - expect undefined)", test_num, A);
        #1;

        check_outputs(3'bxxx);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        A = 8'b11111111;
        $display("Test %0d: Input A = %b (All bits - expect undefined)", test_num, A);
        #1;

        check_outputs(3'bxxx);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        testcase011();
        
        
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
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
