`timescale 1ns/1ps

module bitwise_xor_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_xor dut (
        .a(a),
        .b(b),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 8'h00;
        b = 8'h00;
        $display("Test Case 001: All Zeros (8'h00 ^ 8'h00)");
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 8'hA5;
        b = 8'h00;
        $display("Test Case 002: Identity (8'hA5 ^ 8'h00)");
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 8'hFF;
        b = 8'hFF;
        $display("Test Case 003: Self XOR (8'hFF ^ 8'hFF)");
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 8'h55;
        b = 8'hAA;
        $display("Test Case 004: Complementary bits (8'h55 ^ 8'hAA)");
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 8'hF0;
        b = 8'h0F;
        $display("Test Case 005: High/Low nibbles (8'hF0 ^ 8'h0F)");
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 8'h12;
        b = 8'h34;
        $display("Test Case 006: Arbitrary pattern 1 (8'h12 ^ 8'h34)");
        #1;

        check_outputs(8'h26);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 8'hC3;
        b = 8'h3C;
        $display("Test Case 007: Arbitrary pattern 2 (8'hC3 ^ 8'h3C)");
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 8'h80;
        b = 8'h01;
        $display("Test Case 008: Boundary bits (8'h80 ^ 8'h01)");
        #1;

        check_outputs(8'h81);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_xor Testbench");
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
        input [7:0] expected_result;
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
