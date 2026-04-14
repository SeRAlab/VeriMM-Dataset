`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] control;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .control(control),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 8'd15; B = 8'd25; control = 3'b000;
        #1;

        check_outputs(8'd40);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 8'd100; B = 8'd30; control = 3'b001;
        #1;

        check_outputs(8'd70);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 8'b10101010; B = 8'b11110000; control = 3'b010;
        #1;

        check_outputs(8'b10100000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 8'b10101010; B = 8'b01010101; control = 3'b011;
        #1;

        check_outputs(8'b11111111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 8'b11110000; B = 8'b00111100; control = 3'b100;
        #1;

        check_outputs(8'b11001100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 8'b00000111; B = 8'd1; control = 3'b101;

        #1;


        check_outputs(8'd14);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 8'b10000000; B = 8'd1; control = 3'b110;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 8'd12; B = 8'd10; control = 3'b111;
        #1;

        check_outputs(8'd120);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 8'd250; B = 8'd10; control = 3'b000;
        #1;

        check_outputs(8'd4);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 8'd16; B = 8'd16; control = 3'b111;
        #1;

        check_outputs(8'd0);
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
