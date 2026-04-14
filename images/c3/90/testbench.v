`timescale 1ns/1ps

module Adder_4bit_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    reg clk;
    reg rst;
    wire cout;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Adder_4bit dut (
        .a(a),
        .b(b),
        .cin(cin),
        .clk(clk),
        .rst(rst),
        .cout(cout),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        a = 0;
        b = 0;
        cin = 0;
        #15;
        rst = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Basic addition (4'd5 + 4'd3, cin=0)", test_num);
        reset_dut();
        a = 4'd5;
        b = 4'd3;
        cin = 1'b0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 4'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Addition with carry-in (4'd2 + 4'd2, cin=1)", test_num);
        reset_dut();
        a = 4'd2;
        b = 4'd2;
        cin = 1'b1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 4'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Carry-out generation (4'd12 + 4'd5, cin=0)", test_num);
        reset_dut();
        a = 4'd12;
        b = 4'd5;
        cin = 1'b0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, 4'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Maximum values (4'd15 + 4'd15, cin=1)", test_num);
        reset_dut();
        a = 4'hF;
        b = 4'hF;
        cin = 1'b1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, 4'hF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Zero inputs", test_num);
        reset_dut();
        a = 4'd0;
        b = 4'd0;
        cin = 1'b0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Carry-in ripples to carry-out (4'd15 + 4'd0, cin=1)", test_num);
        reset_dut();
        a = 4'd15;
        b = 4'd0;
        cin = 1'b1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Asynchronous reset verification", test_num);
        reset_dut();

        a = 4'd7;
        b = 4'd7;
        cin = 1'b0;
        @(posedge clk);
        #1;

        if (sum == 4'd14 && cout == 1'b0) begin

            #2 rst = 1;
            #1;
            #1;

            check_outputs(1'b0, 4'd0);
            rst = 0;
        end else begin
            $display("Initial setup failed for reset test");
            fail_count = fail_count + 1;
        end
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Sum reaches exactly 15 (No carry-out)", test_num);
        reset_dut();
        a = 4'd8;
        b = 4'd7;
        cin = 1'b0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0, 4'd15);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Adder_4bit Testbench");
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
        input expected_cout;
        input [3:0] expected_sum;
        begin
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, sum=%h",
                         cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, sum=%h",
                         expected_cout, expected_sum);
                $display("  Got:      cout=%b, sum=%h",
                         cout, sum);
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
        $dumpvars(0,a, b, cin, clk, rst, cout, sum);
    end

endmodule
