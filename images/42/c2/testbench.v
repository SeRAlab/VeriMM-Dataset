`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [1:0] B;
    reg clk;
    reg control;
    reg reset;
    wire COUT;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .control(control),
        .reset(reset),
        .COUT(COUT),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control = 0;
            A = 4'b0000;
            B = 2'b00;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Direct Pass-through (B=00)");
            reset_dut();
            A = 4'b1011;
            B = 2'b00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'b1011);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Shift A Left by 1 (B=01)");
            reset_dut();
            A = 4'b1011;
            B = 2'b01;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'b0110);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Shift A Right by 1 (B=10)");
            reset_dut();
            A = 4'b1011;
            B = 2'b10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'b0101);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Internal Count Increment (B=11, control=1)");
            reset_dut();
            control = 1;
            B = 2'b11;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'b0001);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Internal Count Decrement/Complement (B=11, control=0)");
            reset_dut();
            control = 0;
            B = 2'b11;


            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Testcase 006: Count Overflow (COUT high at 15)");
            reset_dut();
            control = 1;
            B = 2'b11;

            for(i=0; i<15; i=i+1) begin
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(1'b1, 4'b1111);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Count Underflow (COUT high at 0 while decrementing)");
            reset_dut();
            control = 0;
            B = 2'b11;


            @(posedge clk);
            #2;



            #1;




            check_outputs(1'b1, 4'b0000);
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
        input expected_COUT;
        input [3:0] expected_Q;
        begin
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, Q=%h",
                         COUT, Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, Q=%h",
                         expected_COUT, expected_Q);
                $display("  Got:      COUT=%b, Q=%h",
                         COUT, Q);
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
        $dumpvars(0,A, B, clk, control, reset, COUT, Q);
    end

endmodule
