`timescale 1ns/1ps

module alu_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [1:0] ctrl;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    alu_32bit dut (
        .A(A),
        .B(B),
        .ctrl(ctrl),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (A + B) - Simple", test_num);
            A = 32'h0000_000A; B = 32'h0000_0005; ctrl = 2'b00;
            #1;

            check_outputs(32'h0000_000F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (A + B) - Wrap Around", test_num);
            A = 32'hFFFF_FFFF; B = 32'h0000_0001; ctrl = 2'b00;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (A - B) - Simple", test_num);
            A = 32'h0000_0014; B = 32'h0000_0004; ctrl = 2'b01;
            #1;

            check_outputs(32'h0000_0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (A - B) - Zero Result", test_num);
            A = 32'h1234_5678; B = 32'h1234_5678; ctrl = 2'b01;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (A - B) - Negative Result", test_num);
            A = 32'h0000_0000; B = 32'h0000_0001; ctrl = 2'b01;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND (A & B) - Masking", test_num);
            A = 32'hF0F0_F0F0; B = 32'hAAAA_AAAA; ctrl = 2'b10;
            #1;

            check_outputs(32'hA0A0_A0A0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND (A & B) - Zero Result", test_num);
            A = 32'h5555_5555; B = 32'hAAAA_AAAA; ctrl = 2'b10;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND (A & B) - Identity", test_num);
            A = 32'h1234_5678; B = 32'hFFFF_FFFF; ctrl = 2'b10;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (A + B) - Large Hex Values", test_num);
            A = 32'h1111_1111; B = 32'h2222_2222; ctrl = 2'b00;
            #1;

            check_outputs(32'h3333_3333);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (A - B) - 0 minus Max", test_num);
            A = 32'h0000_0000; B = 32'hFFFF_FFFF; ctrl = 2'b01;
            #1;

            check_outputs(32'h0000_0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("alu_32bit Testbench");
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
