`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [34:0] a;
    reg [34:0] b;
    reg clk;
    reg rst;
    wire [34:0] q_sc;
    wire [34:0] q_unsc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
        .q_sc(q_sc),
        .q_unsc(q_unsc)
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
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task run_test;

        input signed [34:0] in_a;
        input signed [34:0] in_b;
        input [127:0] test_name;
        reg signed [69:0] expected_prod;
        begin
            test_num = test_num + 1;
            reset_dut();
            a = in_a;
            b = in_b;
            expected_prod = $signed(in_a) * $signed(in_b);


            repeat(2) @(posedge clk);

            $display("Testcase %0d: %s", test_num, test_name);
            #1;

            check_outputs(expected_prod[69:35], expected_prod[34:0]);
        end
        endtask

    task testcase001;

        begin
            run_test(35'sd10, 35'sd20, "Small Positive Multiplication");
        end
        endtask

    task testcase002;

        begin
            run_test(35'sd100, -35'sd50, "Positive times Negative");
        end
        endtask

    task testcase003;

        begin
            run_test(-35'sd30, -35'sd40, "Negative times Negative");
        end
        endtask

    task testcase004;

        begin
            run_test(35'sd0, 35'sd99999, "Multiplication by Zero");
        end
        endtask

    task testcase005;

        begin
            run_test(35'sd1, -35'sd1, "Identity -1");
        end
        endtask

    task testcase006;

        begin

            run_test(35'sh3FFFFFFFF, 35'sd2, "Max Positive boundary");
        end
        endtask

    task testcase007;

        begin

            run_test(35'sh400000000, 35'sd1, "Min Negative boundary");
        end
        endtask

    task testcase008;

        begin

            run_test(35'sh400000000, -35'sd1, "Min Negative times -1");
        end
        endtask

    task testcase009;

        begin

            run_test(35'sh3FFFFFFFF, 35'sh3FFFFFFFF, "Max Positive Squared");
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
        input [34:0] expected_q_sc;
        input [34:0] expected_q_unsc;
        begin
            if (expected_q_sc === (expected_q_sc ^ q_sc ^ expected_q_sc) &&
                expected_q_unsc === (expected_q_unsc ^ q_unsc ^ expected_q_unsc)) begin
                $display("PASS");
                $display("  Outputs: q_sc=%h, q_unsc=%h",
                         q_sc, q_unsc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q_sc=%h, q_unsc=%h",
                         expected_q_sc, expected_q_unsc);
                $display("  Got:      q_sc=%h, q_unsc=%h",
                         q_sc, q_unsc);
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
        $dumpvars(0,a, b, clk, rst, q_sc, q_unsc);
    end

endmodule
