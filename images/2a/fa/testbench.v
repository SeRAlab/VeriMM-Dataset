`timescale 1ns/1ps

module pipelined_adder_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg rst;
    reg stall;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_adder dut (
        .A(A),
        .B(B),
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            A = 0;
            B = 0;
            stall = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Basic Addition (10 + 20)");
            reset_dut();
            test_num = 1;

            A = 8'd10;
            B = 8'd20;
            @(posedge clk);


            A = 8'd0;
            B = 8'd0;


            repeat (4) @(posedge clk);


            #1 #1;
 check_outputs(8'd30);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Overflow Addition (200 + 100)");
            reset_dut();
            test_num = 2;

            A = 8'd200;
            B = 8'd100;
            @(posedge clk);

            A = 0; B = 0;

            repeat (4) @(posedge clk);
            #1 #1;
 check_outputs(8'd44);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Pipeline Stall (15 + 15 with 3-cycle stall)");
            reset_dut();
            test_num = 3;

            A = 8'd15;
            B = 8'd15;
            @(posedge clk);

            A = 0; B = 0;
            stall = 1;
            repeat (3) @(posedge clk);

            stall = 0;
            repeat (4) @(posedge clk);

            #1 #1;
 check_outputs(8'd30);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Back-to-back Operations");
            reset_dut();
            test_num = 4;

            A = 8'd1; B = 8'd1; @(posedge clk);
            A = 8'd2; B = 8'd2; @(posedge clk);
            A = 8'd3; B = 8'd3; @(posedge clk);
            A = 8'd4; B = 8'd4; @(posedge clk);
            A = 8'd5; B = 8'd5; @(posedge clk);


            #1 if (result !== 8'd2) begin
                $display("Back-to-back Error: First result incorrect");
            end


            repeat (4) @(posedge clk);

            #1 #1;
 check_outputs(8'd10);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Maximum 8-bit Values (255 + 255)");
            reset_dut();
            test_num = 5;

            A = 8'hFF;
            B = 8'hFF;
            @(posedge clk);

            A = 0; B = 0;
            repeat (4) @(posedge clk);

            #1 #1;
 check_outputs(8'hFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_adder Testbench");
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
        input [7:0] expected_result;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,A, B, clk, rst, stall, result);
    end

endmodule
