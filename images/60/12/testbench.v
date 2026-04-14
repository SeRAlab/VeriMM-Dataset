`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg cin;
    reg clk;
    reg rst_n;
    wire cout;
    wire [8:0] sum;

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
        .rst_n(rst_n),
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
            rst_n = 0;
            A = 0;
            B = 0;
            cin = 0;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic addition", test_num);
            reset_dut();
            A = 8'd10;
            B = 8'd20;
            cin = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 9'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Addition with cin", test_num);
            reset_dut();
            A = 8'd100;
            B = 8'd50;
            cin = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 9'd151);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max 8-bit result", test_num);
            reset_dut();
            A = 8'd254;
            B = 8'd1;
            cin = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 9'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry-out generation", test_num);
            reset_dut();
            A = 8'hFF;
            B = 8'h01;
            cin = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 9'h100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum possible values", test_num);
            reset_dut();
            A = 8'hFF;
            B = 8'hFF;
            cin = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 9'h1FF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset verification", test_num);
            reset_dut();
            A = 8'hAA;
            B = 8'h55;
            cin = 0;
            @(posedge clk);
            #1;

            if (sum !== 9'h0FF) begin
                $display("Setup for Reset Test Failed");
            end


            rst_n = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 9'h000);
            rst_n = 1;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero addition", test_num);
            reset_dut();
            A = 8'h00;
            B = 8'h00;
            cin = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 9'h000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Toggle carry-in", test_num);
            reset_dut();
            A = 8'd10;
            B = 8'd10;
            cin = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 9'd21);
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
        input [8:0] expected_sum;
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
        $dumpvars(0,A, B, cin, clk, rst_n, cout, sum);
    end

endmodule
