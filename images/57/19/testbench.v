`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [4:0] aluc;
    reg [31:0] b;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .aluc(aluc),
        .b(b),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (Positive + Positive)", test_num);
            a = 32'h0000000A;
            b = 32'h00000014;
            aluc = 5'b00000;
            #1;

            check_outputs(32'h0000001E);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (Negative + Positive)", test_num);
            a = 32'hFFFFFFFF;
            b = 32'h00000005;
            aluc = 5'b00000;
            #1;

            check_outputs(32'h00000004);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (Large - Small)", test_num);
            a = 32'h00000064;
            b = 32'h00000014;
            aluc = 5'b00001;
            #1;

            check_outputs(32'h00000050);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise AND", test_num);
            a = 32'hF0F0F0F0;
            b = 32'hAAAA5555;
            aluc = 5'b00010;
            #1;

            check_outputs(32'hA0A05050);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise OR", test_num);
            a = 32'hF0F0F0F0;
            b = 32'h0F0F0F0F;
            aluc = 5'b00011;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise XOR", test_num);
            a = 32'h12345678;
            b = 32'hFFFFFFFF;
            aluc = 5'b00100;
            #1;

            check_outputs(32'hEDCBA987);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bitwise NOT (NOR 0)", test_num);
            a = 32'h0000FFFF;
            b = 32'h00000000;
            aluc = 5'b00101;
            #1;

            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logical Shift Left", test_num);
            a = 32'h00000001;
            b = 32'h00000004;
            aluc = 5'b01000;
            #1;

            check_outputs(32'h00000010);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Logical Shift Right", test_num);
            a = 32'h80000000;
            b = 32'h00000002;
            aluc = 5'b01001;
            #1;

            check_outputs(32'h20000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arithmetic Shift Right (Negative)", test_num);
            a = 32'h80000000;
            b = 32'h00000001;
            aluc = 5'b01010;
            #1;

            check_outputs(32'hC0000000);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed Comparison (SLT)", test_num);
            a = 32'hFFFFFFFF;
            b = 32'h00000001;
            aluc = 5'b00110;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unsigned Comparison (SLTU)", test_num);
            a = 32'hFFFFFFFF;
            b = 32'h00000001;
            aluc = 5'b00111;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Undefined ALUC code (Result 0)", test_num);
            a = 32'h12345678;
            b = 32'h87654321;
            aluc = 5'b11111;
            #1;

            check_outputs(32'h00000000);
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
        testcase012();
        testcase013();
        
        
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
        input [31:0] expected_result;
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
