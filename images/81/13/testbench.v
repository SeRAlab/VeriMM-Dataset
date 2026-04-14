`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [23:0] opa;
    reg [23:0] opb;
    wire [47:0] prod;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .opa(opa),
        .opb(opb),
        .prod(prod)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            opa <= 24'd0;
            opb <= 24'd0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Zero Multiplication (0 * 0)", test_num);
            opa <= 24'h0;
            opb <= 24'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(48'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Identity Multiplication (12345 * 1)", test_num);
            opa <= 24'd12345;
            opb <= 24'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(48'd12345);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Small Values (12 * 12)", test_num);
            opa <= 24'd12;
            opb <= 24'd12;
            @(posedge clk);
            #1;
            #1;

            check_outputs(48'd144);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Large Values (0xFFFFFF * 2)", test_num);
            opa <= 24'hFFFFFF;
            opb <= 24'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(48'h1FFFFFE);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Maximum Values (0xFFFFFF * 0xFFFFFF)", test_num);
            opa <= 24'hFFFFFF;
            opb <= 24'hFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(48'hFFFFFE000001);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Powers of 2 (2^10 * 2^10)", test_num);
            opa <= 24'h400;
            opb <= 24'h400;
            @(posedge clk);
            #1;
            #1;

            check_outputs(48'h100000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Zero by Value (0 * 0xABCDEF)", test_num);
            opa <= 24'h0;
            opb <= 24'hABCDEF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(48'h0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Random Product (0x1234 * 0x5678)", test_num);
            opa <= 24'h1234;
            opb <= 24'h5678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(48'h1234 * 48'h5678);
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
        input [47:0] expected_prod;
        begin
            if (expected_prod === (expected_prod ^ prod ^ expected_prod)) begin
                $display("PASS");
                $display("  Outputs: prod=%h",
                         prod);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: prod=%h",
                         expected_prod);
                $display("  Got:      prod=%h",
                         prod);
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
        $dumpvars(0,clk, opa, opb, prod);
    end

endmodule
