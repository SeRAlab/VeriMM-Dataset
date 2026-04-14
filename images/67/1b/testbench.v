`timescale 1ns/1ps

module nor_gate_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nor_gate_16bit dut (
        .a(a),
        .b(b),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: All zeros input");
        a = 16'h0000;
        b = 16'h0000;

        #1;


        check_outputs(16'hFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: All ones input");
        a = 16'hFFFF;
        b = 16'hFFFF;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Complementary patterns (Full coverage of OR)");
        a = 16'hAAAA;
        b = 16'h5555;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Half and half");
        a = 16'hFF00;
        b = 16'h0000;

        #1;


        check_outputs(16'h00FF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Mixed bits");
        a = 16'h1234;
        b = 16'h4321;

        #1;


        check_outputs(16'hACCA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Bitwise independence check");
        a = 16'h0001;
        b = 16'h0002;

        #1;


        check_outputs(16'hFFFC);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Single bit overlap");
        a = 16'h8000;
        b = 16'h8000;

        #1;


        check_outputs(16'h7FFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Random hex pattern");
        a = 16'hC0DE;
        b = 16'hBEEF;

        #1;


        check_outputs(16'h0100);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nor_gate_16bit Testbench");
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
