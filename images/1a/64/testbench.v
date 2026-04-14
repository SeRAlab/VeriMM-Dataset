`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [3:0] ctrl;
    wire [15:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .ctrl(ctrl),
        .result(result),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ADD (0005 + 0002)", test_num);
            A = 16'h0005;
            B = 16'h0002;
            ctrl = 4'b0000;
            #1;

            check_outputs(16'h0007, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SUBTRACT (000A - 000A)", test_num);
            A = 16'h000A;
            B = 16'h000A;
            ctrl = 4'b0001;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: AND (FFFF & 0F0F)", test_num);
            A = 16'hFFFF;
            B = 16'h0F0F;
            ctrl = 4'b0010;
            #1;

            check_outputs(16'h0F0F, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: OR (AAAA | 5555)", test_num);
            A = 16'hAAAA;
            B = 16'h5555;
            ctrl = 4'b0011;
            #1;

            check_outputs(16'hFFFF, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: XOR (F0F0 ^ F0F0)", test_num);
            A = 16'hF0F0;
            B = 16'hF0F0;
            ctrl = 4'b0100;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: NAND (0000 NAND FFFF)", test_num);
            A = 16'h0000;
            B = 16'hFFFF;
            ctrl = 4'b0101;
            #1;

            check_outputs(16'hFFFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: NOR (FFFF NOR 0000)", test_num);
            A = 16'hFFFF;
            B = 16'h0000;
            ctrl = 4'b0110;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: XNOR (AAAA XNOR 5555)", test_num);
            A = 16'hAAAA;
            B = 16'h5555;
            ctrl = 4'b0111;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SLT (-1 < 1)", test_num);
            A = 16'hFFFF;
            B = 16'h0001;
            ctrl = 4'b1000;
            #1;

            check_outputs(16'h0001, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SLT (1 < -1)", test_num);
            A = 16'h0001;
            B = 16'hFFFF;
            ctrl = 4'b1000;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SLL (0001 << 4)", test_num);
            A = 16'h0001;
            B = 16'h0004;
            ctrl = 4'b1001;
            #1;

            check_outputs(16'h0010, 1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SRL (8000 >> 1)", test_num);
            A = 16'h8000;
            B = 16'h0001;
            ctrl = 4'b1010;
            #1;

            check_outputs(16'h4000, 1'b0);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: SRA (8000 >>> 1)", test_num);
            A = 16'h8000;
            B = 16'h0001;
            ctrl = 4'b1011;
            #1;

            check_outputs(16'hC000, 1'b0);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: NOT (FFFF)", test_num);
            A = 16'hFFFF;
            B = 16'h0000;
            ctrl = 4'b1100;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase015;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: PASS A (1234)", test_num);
            A = 16'h1234;
            B = 16'h5678;
            ctrl = 4'b1101;
            #1;

            check_outputs(16'h1234, 1'b0);
        end
        endtask

    task testcase016;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: PASS B (5678)", test_num);
            A = 16'h1234;
            B = 16'h5678;
            ctrl = 4'b1110;
            #1;

            check_outputs(16'h5678, 1'b0);
        end
        endtask

    task testcase017;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: ZERO (Always 0)", test_num);
            A = 16'hFFFF;
            B = 16'hFFFF;
            ctrl = 4'b1111;
            #1;

            check_outputs(16'h0000, 1'b1);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        testcase017();
        
        
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
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: result=%h, zero=%b",
                         result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, zero=%b",
                         expected_result, expected_zero);
                $display("  Got:      result=%h, zero=%b",
                         result, zero);
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
