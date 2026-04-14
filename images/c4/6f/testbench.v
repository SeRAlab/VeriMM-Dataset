`timescale 1ns/1ps

module calculator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [1:0] opcode;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    calculator dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Addition (10 + 20)", test_num);
            A = 8'd10;
            B = 8'd20;
            opcode = 2'b00;
            #1;

            check_outputs(16'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Addition (255 + 255)", test_num);
            A = 8'hFF;
            B = 8'hFF;
            opcode = 2'b00;
            #1;

            check_outputs(16'd510);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Subtraction (100 - 40)", test_num);
            A = 8'd100;
            B = 8'd40;
            opcode = 2'b01;
            #1;

            check_outputs(16'd60);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Subtraction (50 - 50)", test_num);
            A = 8'd50;
            B = 8'd50;
            opcode = 2'b01;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Subtraction (10 - 20)", test_num);
            A = 8'd10;
            B = 8'd20;
            opcode = 2'b01;

            #1;


            check_outputs(16'hFFF6);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Multiplication (12 * 10)", test_num);
            A = 8'd12;
            B = 8'd10;
            opcode = 2'b10;
            #1;

            check_outputs(16'd120);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Multiplication (255 * 255)", test_num);
            A = 8'hFF;
            B = 8'hFF;
            opcode = 2'b10;
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Division (100 / 5)", test_num);
            A = 8'd100;
            B = 8'd5;
            opcode = 2'b11;
            #1;

            check_outputs(16'd20);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Division (7 / 3)", test_num);
            A = 8'd7;
            B = 8'd3;
            opcode = 2'b11;
            #1;

            check_outputs(16'd2);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Division (5 / 10)", test_num);
            A = 8'd5;
            B = 8'd10;
            opcode = 2'b11;
            #1;

            check_outputs(16'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("calculator Testbench");
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
