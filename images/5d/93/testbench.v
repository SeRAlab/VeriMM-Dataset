`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in1;
    reg [31:0] in2;
    reg [3:0] opCode;
    reg [4:0] shiftAmt;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .opCode(opCode),
        .shiftAmt(shiftAmt),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        in1 = 32'd100; in2 = 32'd250; opCode = 4'd0; shiftAmt = 5'd0;
        #1;

        check_outputs(32'd350);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        in1 = -32'd50; in2 = 32'd20; opCode = 4'd0; shiftAmt = 5'd0;
        #1;

        check_outputs(-32'd30);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        in1 = 32'd500; in2 = 32'd150; opCode = 4'd1; shiftAmt = 5'd0;
        #1;

        check_outputs(32'd350);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        in1 = 32'd10; in2 = 32'd20; opCode = 4'd1; shiftAmt = 5'd0;
        #1;

        check_outputs(-32'd10);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        in1 = 32'h0F0F0F0F; in2 = 32'hFFFF0000; opCode = 4'd2; shiftAmt = 5'd0;
        #1;

        check_outputs(32'h0F0F0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        in1 = 32'hAAAA0000; in2 = 32'h00005555; opCode = 4'd3; shiftAmt = 5'd0;
        #1;

        check_outputs(32'hAAAA5555);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        in1 = 32'h00000001; in2 = 32'd0; opCode = 4'd4; shiftAmt = 5'd4;
        #1;

        check_outputs(32'h00000010);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in1 = 32'h80000000; in2 = 32'd0; opCode = 4'd5; shiftAmt = 5'd4;
        #1;

        check_outputs(32'h08000000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        in1 = 32'h80000000; in2 = 32'd0; opCode = 4'd6; shiftAmt = 5'd4;
        #1;

        check_outputs(32'hF8000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        in1 = -32'd10; in2 = 32'd5; opCode = 4'd7; shiftAmt = 5'd0;
        #1;

        check_outputs(32'd1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        in1 = -32'd10; in2 = -32'd20; opCode = 4'd8; shiftAmt = 5'd0;
        #1;

        check_outputs(32'd1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        in1 = 32'd5; in2 = 32'd10; opCode = 4'd8; shiftAmt = 5'd0;
        #1;

        check_outputs(32'd0);
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
