`timescale 1ns/1ps

module adder_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg rst;
    wire [7:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .rst(rst),
        .R(R)
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
        #15;
        rst = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        A = 8'd10;
        B = 8'd20;
        @(posedge clk);
        #1;
        $display("Test %0d: A=%d, B=%d -> R=A+B+1", test_num, A, B);
        #1;

        check_outputs(8'd31);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        A = 8'd0;
        B = 8'd0;
        @(posedge clk);
        #1;
        $display("Test %0d: A=%d, B=%d -> R=A+B+1", test_num, A, B);
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        A = 8'hFF;
        B = 8'hFF;
        @(posedge clk);
        #1;
        $display("Test %0d: A=%h, B=%h -> R=A+B+1 (Overflow)", test_num, A, B);

        #1;


        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        A = 8'd127;
        B = 8'd127;
        @(posedge clk);
        #1;
        $display("Test %0d: A=%d, B=%d -> R=A+B+1", test_num, A, B);
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        A = 8'd100;
        B = 8'd155;
        @(posedge clk);
        #1;
        $display("Test %0d: A=%d, B=%d -> R=A+B+1 (Wrap to 0)", test_num, A, B);

        #1;


        check_outputs(8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        A = 8'd50;
        B = 8'd50;
        @(posedge clk);
        #1;


        rst = 1;
        #2;
        $display("Test %0d: Verifying asynchronous reset", test_num);
        #1;

        check_outputs(8'd0);
        rst = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_module Testbench");
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
        input [7:0] expected_R;
        begin
            if (expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: R=%h",
                         R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R=%h",
                         expected_R);
                $display("  Got:      R=%h",
                         R);
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
        $dumpvars(0,A, B, clk, rst, R);
    end

endmodule
