`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cin;
    reg clk;
    reg reset;
    wire cout;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .clk(clk),
        .reset(reset),
        .cout(cout),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            cin = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Reset", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single Increment", test_num);
            reset_dut();
            cin = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Cin Hold (cin=0)", test_num);
            reset_dut();
            cin = 1;
            repeat(3) @(posedge clk);
            cin = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reach Max Value and check Cout", test_num);
            reset_dut();
            cin = 1;
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Wrap around from Max to 0", test_num);
            reset_dut();
            cin = 1;
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Cout should be low if cin is low even at Max", test_num);
            reset_dut();
            cin = 1;
            repeat(15) @(posedge clk);
            cin = 0;
            #1;
            #1;

            check_outputs(1'b0, 4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Synchronous reset while counting", test_num);
            reset_dut();
            cin = 1;
            repeat(8) @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            #1;

            check_outputs(1'b0, 4'h0);
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
        input [3:0] expected_q;
        begin
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, q=%h",
                         cout, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, q=%h",
                         expected_cout, expected_q);
                $display("  Got:      cout=%b, q=%h",
                         cout, q);
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
        $dumpvars(0,cin, clk, reset, cout, q);
    end

endmodule
