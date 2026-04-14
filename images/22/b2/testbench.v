`timescale 1ns/1ps

module LU_decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] a;
    reg [1:0] b;
    reg [1:0] c;
    reg [1:0] d;
    wire [3:0] L;
    wire [3:0] U;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LU_decomposition dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .L(L),
        .U(U)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity-like Matrix", test_num);
            a = 2'b01; b = 2'b00; c = 2'b00; d = 2'b01;
            #1;

            check_outputs(4'b1001, 4'b1001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Calculation", test_num);
            a = 2'b01; b = 2'b01; c = 2'b01; d = 2'b01;
            #1;

            check_outputs(4'b1011, 4'b1100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: L21 Zero check", test_num);
            a = 2'b00; b = 2'b01; c = 2'b00; d = 2'b01;
            #1;

            check_outputs(4'b1001, 4'b0101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: U22 Subtraction", test_num);
            a = 2'b01; b = 2'b01; c = 2'b00; d = 2'b01;
            #1;

            check_outputs(4'b1001, 4'b1101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 2-bit Input Handling", test_num);
            a = 2'b01; b = 2'b01; c = 2'b10; d = 2'b10;
            #1;

            check_outputs(4'b1011, 4'b1101);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division Floor and Truncation", test_num);
            a = 2'b01; b = 2'b01; c = 2'b01; d = 2'b10;
            #1;

            check_outputs(4'b1001, 4'b1100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LU_decomposition Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [3:0] expected_L;
        input [3:0] expected_U;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_L === (expected_L ^ L ^ expected_L) &&
                expected_U === (expected_U ^ U ^ expected_U)) begin
                $display("PASS");
                $display("  Outputs: L=%h, U=%h",
                         L, U);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: L=%h, U=%h",
                         expected_L, expected_U);
                $display("  Got:      L=%h, U=%h",
                         L, U);
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
