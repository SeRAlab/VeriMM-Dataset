`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg CLK;
    reg [2:0] OP;
    reg RST_N;
    wire RDY;
    wire [7:0] RESULT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .OP(OP),
        .RST_N(RST_N),
        .RDY(RDY),
        .RESULT(RESULT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST_N = 1'b0;
            A = 8'h0;
            B = 8'h0;
            OP = 3'b000;
            #15;
            RST_N = 1'b1;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            A = 8'sd15; B = 8'sd25; OP = 3'b000;
            @(posedge CLK); #1;
            #1;

            check_outputs(1'b1, 8'sd40);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            A = 8'sd100; B = 8'sd50; OP = 3'b000;
            @(posedge CLK); #1;
            #1;

            check_outputs(1'b1, 8'sd127);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            A = 8'sd10; B = 8'sd20; OP = 3'b001;
            @(posedge CLK); #1;
            #1;

            check_outputs(1'b1, -8'sd10);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            A = -8'sd100; B = 8'sd50; OP = 3'b001;
            @(posedge CLK); #1;
            #1;

            check_outputs(1'b1, -8'sd128);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            A = 8'sd5; B = -8'sd4; OP = 3'b010;
            @(posedge CLK); #1;
            #1;

            check_outputs(1'b1, -8'sd20);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            A = 8'sd20; B = 8'sd10; OP = 3'b010;
            @(posedge CLK); #1;
            #1;

            check_outputs(1'b1, 8'sd127);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            A = -8'sd20; B = 8'sd10; OP = 3'b010;
            @(posedge CLK); #1;
            #1;

            check_outputs(1'b1, -8'sd128);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            A = 8'sd100; B = 8'sd3; OP = 3'b011;
            @(posedge CLK); #1;
            #1;

            check_outputs(1'b1, 8'sd33);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            A = 8'sd10; B = 8'sd3; OP = 3'b100;
            @(posedge CLK); #1;
            #1;

            check_outputs(1'b1, 8'sd1);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            A = 8'sd10; B = 8'sd10; OP = 3'b000;
            RST_N = 1'b0;
            #5;
            #1;

            check_outputs(1'b0, 8'sd0);
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
        input expected_RDY;
        input [7:0] expected_RESULT;
        begin
            if (expected_RDY === (expected_RDY ^ RDY ^ expected_RDY) &&
                expected_RESULT === (expected_RESULT ^ RESULT ^ expected_RESULT)) begin
                $display("PASS");
                $display("  Outputs: RDY=%b, RESULT=%h",
                         RDY, RESULT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RDY=%b, RESULT=%h",
                         expected_RDY, expected_RESULT);
                $display("  Got:      RDY=%b, RESULT=%h",
                         RDY, RESULT);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,A, B, CLK, OP, RST_N, RDY, RESULT);
    end

endmodule
