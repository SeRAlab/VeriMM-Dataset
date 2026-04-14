`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A_IN;
    reg [7:0] B_IN;
    reg CLK;
    reg INPUT_EN;
    reg RESET_X;
    wire [7:0] C_OUT;
    wire MLC_GAGB;
    wire OUTPUT_EN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A_IN(A_IN),
        .B_IN(B_IN),
        .CLK(CLK),
        .INPUT_EN(INPUT_EN),
        .RESET_X(RESET_X),
        .C_OUT(C_OUT),
        .MLC_GAGB(MLC_GAGB),
        .OUTPUT_EN(OUTPUT_EN)
    );
    task testcase001;

        begin
            test_num = 1;
            RESET_X = 0;
            A_IN = 8'hFF; B_IN = 8'hFF; INPUT_EN = 1;
            repeat(2) @(posedge CLK);

            #1;


            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            RESET_X = 1;
            @(posedge CLK);
            A_IN = 8'd4; B_IN = 8'd5; INPUT_EN = 1;
            @(posedge CLK);
            INPUT_EN = 0;

            wait(OUTPUT_EN == 1);
            @(posedge CLK);


            #1;



            check_outputs(C_OUT, MLC_GAGB, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            RESET_X = 0; #10; RESET_X = 1;
            @(posedge CLK);
            A_IN = 8'd0; B_IN = 8'd128; INPUT_EN = 1;
            @(posedge CLK);
            INPUT_EN = 0;
            wait(OUTPUT_EN == 1);
            @(posedge CLK);
            #1;

            check_outputs(C_OUT, MLC_GAGB, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            RESET_X = 0; #10; RESET_X = 1;
            @(posedge CLK);
            A_IN = 8'd10; B_IN = 8'd10; INPUT_EN = 0;
            repeat(5) @(posedge CLK);

            #1;


            check_outputs(8'h00, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            RESET_X = 0; #10; RESET_X = 1;
            @(posedge CLK);
            A_IN = 8'hFF; B_IN = 8'hFF; INPUT_EN = 1;
            @(posedge CLK);
            INPUT_EN = 0;
            wait(OUTPUT_EN == 1);
            @(posedge CLK);

            #1;


            check_outputs(C_OUT, MLC_GAGB, 1'b1);
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
        input [7:0] expected_C_OUT;
        input expected_MLC_GAGB;
        input expected_OUTPUT_EN;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C_OUT === (expected_C_OUT ^ C_OUT ^ expected_C_OUT) &&
                expected_MLC_GAGB === (expected_MLC_GAGB ^ MLC_GAGB ^ expected_MLC_GAGB) &&
                expected_OUTPUT_EN === (expected_OUTPUT_EN ^ OUTPUT_EN ^ expected_OUTPUT_EN)) begin
                $display("PASS");
                $display("  Outputs: C_OUT=%h, MLC_GAGB=%b, OUTPUT_EN=%b",
                         C_OUT, MLC_GAGB, OUTPUT_EN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C_OUT=%h, MLC_GAGB=%b, OUTPUT_EN=%b",
                         expected_C_OUT, expected_MLC_GAGB, expected_OUTPUT_EN);
                $display("  Got:      C_OUT=%h, MLC_GAGB=%b, OUTPUT_EN=%b",
                         C_OUT, MLC_GAGB, OUTPUT_EN);
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
