`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] input1;
    reg [4:0] input2;
    reg [5:0] input3;
    reg [6:0] input4;
    reg [7:0] input5;
    wire [15:0] output1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input1(input1),
        .input2(input2),
        .input3(input3),
        .input4(input4),
        .input5(input5),
        .output1(output1)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros", test_num);
        input1 = 4'd0; input2 = 5'd0; input3 = 6'd0; input4 = 7'd0; input5 = 8'd0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple Mixed Values", test_num);
        input1 = 4'h2;
        input2 = 5'h05;
        input3 = 6'h05;
        input4 = 7'h10;
        input5 = 8'h20;

        #1;


        check_outputs(16'h60A4);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum Values and Wraparound", test_num);
        input1 = 4'hF;
        input2 = 5'h1F;
        input3 = 6'h3F;
        input4 = 7'h7F;
        input5 = 8'hFF;

        #1;


        check_outputs(16'hFFEE);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: OR logic and input width handling", test_num);
        input1 = 4'h8;
        input2 = 5'h10;
        input3 = 6'h10;
        input4 = 7'h55;
        input5 = 8'hAA;


        #1;



        check_outputs(16'hFE00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition boundary check", test_num);
        input1 = 4'h4;
        input2 = 5'h1F;
        input3 = 6'h01;
        input4 = 7'h01;
        input5 = 8'h01;

        #1;


        check_outputs(16'h0208);
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
        input [15:0] expected_output1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output1 === (expected_output1 ^ output1 ^ expected_output1)) begin
                $display("PASS");
                $display("  Outputs: output1=%h",
                         output1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output1=%h",
                         expected_output1);
                $display("  Got:      output1=%h",
                         output1);
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
