`timescale 1ns/1ps

module ALU_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    reg [1:0] control;
    wire [63:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_64bit dut (
        .A(A),
        .B(B),
        .control(control),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition (Small numbers)", test_num);
            A = 64'd100;
            B = 64'd250;
            control = 2'b00;
            #1;

            check_outputs(64'd350);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition (Overflow/Wrap-around)", test_num);
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'h0000000000000001;
            control = 2'b00;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction (A > B)", test_num);
            A = 64'h00000000000000FF;
            B = 64'h0000000000000001;
            control = 2'b01;
            #1;

            check_outputs(64'h00000000000000FE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction (A < B, Negative Result)", test_num);
            A = 64'd10;
            B = 64'd20;
            control = 2'b01;

            #1;


            check_outputs(64'hFFFFFFFFFFFFFFF6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bitwise AND", test_num);
            A = 64'hF0F0F0F0F0F0F0F0;
            B = 64'h0F0F0F0F0F0F0F0F;
            control = 2'b10;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bitwise AND (Masking)", test_num);
            A = 64'hFEDCBA9876543210;
            B = 64'hFFFFFFFF00000000;
            control = 2'b10;
            #1;

            check_outputs(64'hFEDCBA9800000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bitwise OR", test_num);
            A = 64'hAAAA0000AAAA0000;
            B = 64'h0000555500005555;
            control = 2'b11;
            #1;

            check_outputs(64'hAAAA5555AAAA5555);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bitwise OR (All ones)", test_num);
            A = 64'hFFFFFFFF00000000;
            B = 64'h00000000FFFFFFFF;
            control = 2'b11;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Complex Addition", test_num);
            A = 64'h1234567812345678;
            B = 64'h8765432187654321;
            control = 2'b00;
            #1;

            check_outputs(64'h9999999999999999);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Identity Subtraction (Zero)", test_num);
            A = 64'hABCDE0123456789F;
            B = 64'hABCDE0123456789F;
            control = 2'b01;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_64bit Testbench");
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
        input [63:0] expected_result;
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
