`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cin;
    reg clk;
    reg [3:0] in1;
    reg [3:0] in2;
    reg reset;
    wire cout;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .clk(clk),
        .in1(in1),
        .in2(in2),
        .reset(reset),
        .cout(cout),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in1 = 4'd0;
            in2 = 4'd0;
            cin = 1'b0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Addition (5 + 2 + 0)", test_num);
            reset_dut();
            in1 = 4'd5;
            in2 = 4'd2;
            cin = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Addition with cin (4 + 4 + 1)", test_num);
            reset_dut();
            in1 = 4'd4;
            in2 = 4'd4;
            cin = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd9);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max value without overflow (10 + 5 + 0)", test_num);
            reset_dut();
            in1 = 4'd10;
            in2 = 4'd5;
            cin = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Carry-out test (8 + 8 + 0)", test_num);
            reset_dut();
            in1 = 4'd8;
            in2 = 4'd8;
            cin = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Maximum sum test (15 + 15 + 1)", test_num);
            reset_dut();
            in1 = 4'd15;
            in2 = 4'd15;
            cin = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous Reset Check", test_num);

            in1 = 4'hf;
            in2 = 4'hf;
            cin = 1'b1;
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd0);
            reset = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Adding Zeros (0 + 0 + 0)", test_num);
            reset_dut();
            in1 = 4'd0;
            in2 = 4'd0;
            cin = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd0);
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
        input expected_cout;
        input [3:0] expected_out;
        begin
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, out=%h",
                         cout, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, out=%h",
                         expected_cout, expected_out);
                $display("  Got:      cout=%b, out=%h",
                         cout, out);
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
        $dumpvars(0,cin, clk, in1, in2, reset, cout, out);
    end

endmodule
