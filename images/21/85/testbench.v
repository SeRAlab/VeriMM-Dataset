`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] func;
    wire [7:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .func(func),
        .result(result),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 8'hAA; B = 8'hF0; func = 3'b000;
        $display("Test %0d: AND operation (AA & F0)", test_num);
        #1;

        check_outputs(8'hA0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 8'h55; B = 8'h0F; func = 3'b001;
        $display("Test %0d: OR operation (55 | 0F)", test_num);
        #1;

        check_outputs(8'h5F, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 8'd120; B = 8'd35; func = 3'b010;
        $display("Test %0d: ADD operation (120 + 35)", test_num);
        #1;

        check_outputs(8'd155, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 8'd100; B = 8'd40; func = 3'b011;
        $display("Test %0d: SUBTRACT operation (100 - 40)", test_num);
        #1;

        check_outputs(8'd60, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 8'hFF; B = 8'hAA; func = 3'b100;
        $display("Test %0d: XOR operation (FF ^ AA)", test_num);
        #1;

        check_outputs(8'h55, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 8'h0F; B = 8'hFF; func = 3'b101;
        $display("Test %0d: NOT operation (~0F, ignore B)", test_num);
        #1;

        check_outputs(8'hF0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 8'b1000_0001; B = 8'h01; func = 3'b110;
        $display("Test %0d: SHIFT LEFT operation (81 << 1)", test_num);
        #1;

        check_outputs(8'b0000_0010, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 8'b1000_0001; B = 8'h01; func = 3'b111;
        $display("Test %0d: SHIFT RIGHT operation (81 >> 1)", test_num);
        #1;

        check_outputs(8'b0100_0000, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 8'hFF; B = 8'h01; func = 3'b010;
        $display("Test %0d: ADD Overflow (FF + 01)", test_num);
        #1;

        check_outputs(8'h00, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 8'h00; B = 8'h01; func = 3'b011;
        $display("Test %0d: SUB Underflow (00 - 01)", test_num);
        #1;

        check_outputs(8'hFF, 1'b1);
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
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: result=%h, valid=%b",
                         result, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, valid=%b",
                         expected_result, expected_valid);
                $display("  Got:      result=%h, valid=%b",
                         result, valid);
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
