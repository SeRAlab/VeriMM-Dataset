`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg CLK;
    reg NEG;
    reg [1:0] OP;
    reg RESET;
    wire [7:0] OUT;
    wire [6:0] SEG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CLK(CLK),
        .NEG(NEG),
        .OP(OP),
        .RESET(RESET),
        .OUT(OUT),
        .SEG(SEG)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            A = 0;
            B = 0;
            OP = 0;
            NEG = 0;
            repeat (2) @(posedge CLK);
            RESET = 0;
            repeat (1) @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition (15 + 10)", test_num);
            reset_dut();
            A = 8'd15;
            B = 8'd10;
            OP = 2'b00;
            NEG = 1'b0;
            repeat (10) @(posedge CLK);
            #1;

            check_outputs(8'd25, 7'h6D);


            #1;



            check_outputs(8'h19, 7'h6F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction (50 - 20)", test_num);
            reset_dut();
            A = 8'd50;
            B = 8'd20;
            OP = 2'b01;
            NEG = 1'b0;
            repeat (10) @(posedge CLK);
            #1;

            check_outputs(8'd30, 7'h79);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication (4 * 3)", test_num);
            reset_dut();
            A = 8'd4;
            B = 8'd3;
            OP = 2'b10;
            NEG = 1'b0;
            repeat (10) @(posedge CLK);
            #1;

            check_outputs(8'd12, 7'h39);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Division (20 / 4)", test_num);
            reset_dut();
            A = 8'd20;
            B = 8'd4;
            OP = 2'b11;
            NEG = 1'b0;
            repeat (10) @(posedge CLK);
            #1;

            check_outputs(8'd5, 7'h6D);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with NEG (-(5 + 5))", test_num);
            reset_dut();
            A = 8'd5;
            B = 8'd5;
            OP = 2'b00;
            NEG = 1'b1;
            repeat (10) @(posedge CLK);

            #1;


            check_outputs(8'hF6, 7'h7D);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction Negative Result (10 - 15)", test_num);
            reset_dut();
            A = 8'd10;
            B = 8'd15;
            OP = 2'b01;
            NEG = 1'b0;
            repeat (10) @(posedge CLK);

            #1;


            check_outputs(8'hFB, 7'h7C);
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
        input [7:0] expected_OUT;
        input [6:0] expected_SEG;
        begin
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT) &&
                expected_SEG === (expected_SEG ^ SEG ^ expected_SEG)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h, SEG=%h",
                         OUT, SEG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h, SEG=%h",
                         expected_OUT, expected_SEG);
                $display("  Got:      OUT=%h, SEG=%h",
                         OUT, SEG);
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
        $dumpvars(0,A, B, CLK, NEG, OP, RESET, OUT, SEG);
    end

endmodule
