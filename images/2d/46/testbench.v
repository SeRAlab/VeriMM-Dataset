`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] SEL;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .SEL(SEL),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 8'h05; B = 8'h03; SEL = 3'b000;
            $display("Test %0d: Addition (000) - 8'h05 + 8'h03", test_num);
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 8'hFF; B = 8'h01; SEL = 3'b000;
            $display("Test %0d: Addition (000) - 8'hFF + 8'h01", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 8'h0A; B = 8'h04; SEL = 3'b001;
            $display("Test %0d: Subtraction (001) - 8'h0A - 8'h04", test_num);
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 8'h00; B = 8'h01; SEL = 3'b001;
            $display("Test %0d: Subtraction (001) - 8'h00 - 8'h01", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 8'hAA; B = 8'h55; SEL = 3'b010;
            $display("Test %0d: Bitwise AND (010) - 8'hAA & 8'h55", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 8'hF0; B = 8'h0F; SEL = 3'b010;
            $display("Test %0d: Bitwise AND (010) - 8'hF0 & 8'h0F", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 8'hAA; B = 8'h55; SEL = 3'b011;
            $display("Test %0d: Bitwise OR (011) - 8'hAA | 8'h55", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 8'hCC; B = 8'h33; SEL = 3'b100;
            $display("Test %0d: Bitwise XOR (100) - 8'hCC ^ 8'h33", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 8'hFF; B = 8'hFF; SEL = 3'b100;
            $display("Test %0d: Bitwise XOR (100) - 8'hFF ^ 8'hFF", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 8'h12; B = 8'h34; SEL = 3'b000;
            $display("Test %0d: Addition (000) - 8'h12 + 8'h34", test_num);
            #1;

            check_outputs(8'h46);
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
