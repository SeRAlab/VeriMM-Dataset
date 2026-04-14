`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg cin;
    reg clk;
    wire [3:0] S;
    wire cout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .cin(cin),
        .clk(clk),
        .S(S),
        .cout(cout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            A <= 4'd0;
            B <= 4'd0;
            cin <= 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=3, B=4, cin=0", test_num);
            reset_dut();
            @(posedge clk);
            A <= 4'd3;
            B <= 4'd4;
            cin <= 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd7, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=2, B=2, cin=1", test_num);
            reset_dut();
            @(posedge clk);
            A <= 4'd2;
            B <= 4'd2;
            cin <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=7, B=8, cin=0", test_num);
            reset_dut();
            @(posedge clk);
            A <= 4'd7;
            B <= 4'd8;
            cin <= 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd15, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=8, B=8, cin=0", test_num);
            reset_dut();
            @(posedge clk);
            A <= 4'd8;
            B <= 4'd8;
            cin <= 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=15, B=15, cin=1", test_num);
            reset_dut();
            @(posedge clk);
            A <= 4'hF;
            B <= 4'hF;
            cin <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=15, B=0, cin=1", test_num);
            reset_dut();
            @(posedge clk);
            A <= 4'd15;
            B <= 4'd0;
            cin <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=0, B=0, cin=1", test_num);
            reset_dut();
            @(posedge clk);
            A <= 4'd0;
            B <= 4'd0;
            cin <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd1, 1'b0);
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
        input [3:0] expected_S;
        input expected_cout;
        begin
            if (expected_S === (expected_S ^ S ^ expected_S) &&
                expected_cout === (expected_cout ^ cout ^ expected_cout)) begin
                $display("PASS");
                $display("  Outputs: S=%h, cout=%b",
                         S, cout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h, cout=%b",
                         expected_S, expected_cout);
                $display("  Got:      S=%h, cout=%b",
                         S, cout);
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
        $dumpvars(0,A, B, cin, clk, S, cout);
    end

endmodule
