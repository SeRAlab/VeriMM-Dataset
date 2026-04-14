`timescale 1ns/1ps

module xor_gate_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    xor_gate dut (
        .a(a),
        .b(b),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros (0000 ^ 0000 = 0000)", test_num);
        a = 4'b0000;
        b = 4'b0000;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones (1111 ^ 1111 = 0000)", test_num);
        a = 4'b1111;
        b = 4'b1111;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identity with Zero (1010 ^ 0000 = 1010)", test_num);
        a = 4'b1010;
        b = 4'b0000;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Complementary Bits (1010 ^ 0101 = 1111)", test_num);
        a = 4'b1010;
        b = 4'b0101;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single Bit Toggle (0001 ^ 0011 = 0010)", test_num);
        a = 4'b0001;
        b = 4'b0011;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: High Bit Toggle (1000 ^ 0000 = 1000)", test_num);
        a = 4'b1000;
        b = 4'b0000;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple Bit Difference (1100 ^ 1001 = 0101)", test_num);
        a = 4'b1100;
        b = 4'b1001;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum Value XOR Minimum (1111 ^ 0001 = 1110)", test_num);
        a = 4'b1111;
        b = 4'b0001;
        #1;

        check_outputs(4'b1110);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("xor_gate Testbench");
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
        input [3:0] expected_result;
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
