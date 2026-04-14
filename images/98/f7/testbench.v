`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg [1:0] control;
    reg [15:0] in1;
    reg [15:0] in2;
    reg [15:0] in3;
    reg [15:0] in4;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .control(control),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in1", test_num);
            in1 = 16'hAAAA;
            in2 = 16'h5555;
            in3 = 16'hCCCC;
            in4 = 16'h3333;
            control = 2'b00;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in2", test_num);
            in1 = 16'hAAAA;
            in2 = 16'h5555;
            in3 = 16'hCCCC;
            in4 = 16'h3333;
            control = 2'b01;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in3", test_num);
            in1 = 16'hAAAA;
            in2 = 16'h5555;
            in3 = 16'hCCCC;
            in4 = 16'h3333;
            control = 2'b10;
            #1;

            check_outputs(16'hCCCC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in4", test_num);
            in1 = 16'hAAAA;
            in2 = 16'h5555;
            in3 = 16'hCCCC;
            in4 = 16'h3333;
            control = 2'b11;
            #1;

            check_outputs(16'h3333);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            in1 = 16'h0000;
            in2 = 16'h0000;
            in3 = 16'h0000;
            in4 = 16'h0000;
            control = 2'b10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs 0xFFFF", test_num);
            in1 = 16'hFFFF;
            in2 = 16'hFFFF;
            in3 = 16'hFFFF;
            in4 = 16'hFFFF;
            control = 2'b01;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Change input while selected", test_num);
            control = 2'b00;
            in1 = 16'h1234;
            #5;
            in1 = 16'hABCD;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Cycle through controls", test_num);
            in1 = 16'h0001;
            in2 = 16'h0002;
            in3 = 16'h0004;
            in4 = 16'h0008;

            control = 2'b11;
            #5;
            control = 2'b01;
            #1;

            check_outputs(16'h0002);
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
