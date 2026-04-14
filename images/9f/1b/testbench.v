`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg Add;
    reg [3:0] B;
    reg Sub;
    reg clk;
    reg reset;
    wire [3:0] O;
    wire V;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .Add(Add),
        .B(B),
        .Sub(Sub),
        .clk(clk),
        .reset(reset),
        .O(O),
        .V(V)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            A = 0;
            B = 0;
            Add = 0;
            Sub = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            A = 4'd5; B = 4'd3; Add = 1'b1; Sub = 1'b0;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd8, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            A = 4'd10; B = 4'd5; Add = 1'b1; Sub = 1'b0;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd15, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            A = 4'd10; B = 4'd7; Add = 1'b1; Sub = 1'b0;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            A = 4'd15; B = 4'd1; Add = 1'b1; Sub = 1'b0;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            A = 4'd10; B = 4'd4; Add = 1'b0; Sub = 1'b1;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd6, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            A = 4'd8; B = 4'd8; Add = 1'b0; Sub = 1'b1;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            A = 4'd3; B = 4'd5; Add = 1'b0; Sub = 1'b1;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd14, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            A = 4'd0; B = 4'd1; Add = 1'b0; Sub = 1'b1;
            @(posedge clk);
            #2 #1;
 check_outputs(4'd15, 1'b1);
        end
        endtask

    task testcase009;

        begin

            A = 4'd7; B = 4'd2; Add = 1'b1; Sub = 1'b0;
            @(posedge clk);
            #2;
            reset = 1;
            #1;
            if (O === 4'd0) begin
                $display("Test 009: PASS | Async Reset verified");
                pass_count = pass_count + 1;
            end else begin
                $display("Test 009: FAIL | Async Reset failed. O=%d", O);
                fail_count = fail_count + 1;
            end
            test_num = test_num + 1;
            reset = 0;
            @(posedge clk);
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
        input [3:0] expected_O;
        input expected_V;
        begin
            if (expected_O === (expected_O ^ O ^ expected_O) &&
                expected_V === (expected_V ^ V ^ expected_V)) begin
                $display("PASS");
                $display("  Outputs: O=%h, V=%b",
                         O, V);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h, V=%b",
                         expected_O, expected_V);
                $display("  Got:      O=%h, V=%b",
                         O, V);
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
        $dumpvars(0,A, Add, B, Sub, clk, reset, O, V);
    end

endmodule
