`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg ce;
    reg clk;
    wire [15:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ce(ce),
        .clk(clk),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a <= 8'd0;
            b <= 8'd0;
            ce <= 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 0 * 0", test_num);
            @(posedge clk);
            a <= 8'sd0; b <= 8'sd0; ce <= 1;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 12 * 5", test_num);
            @(posedge clk);
            a <= 8'sd12; b <= 8'sd5; ce <= 1;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'sd60);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: -5 * 4", test_num);
            @(posedge clk);
            a <= -8'sd5; b <= 8'sd4; ce <= 1;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'hFFEC);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 7 * -3", test_num);
            @(posedge clk);
            a <= 8'sd7; b <= -8'sd3; ce <= 1;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'hFFEB);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: -10 * -10", test_num);
            @(posedge clk);
            a <= -8'sd10; b <= -8'sd10; ce <= 1;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'sd100);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: 127 * 127", test_num);
            @(posedge clk);
            a <= 8'sd127; b <= 8'sd127; ce <= 1;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'sd16129);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: -128 * -128", test_num);
            @(posedge clk);
            a <= -8'sd128; b <= -8'sd128; ce <= 1;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'sd16384);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: -128 * 127", test_num);
            @(posedge clk);
            a <= -8'sd128; b <= 8'sd127; ce <= 1;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'hC080);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: -1 * 1", test_num);
            @(posedge clk);
            a <= -8'sd1; b <= 8'sd1; ce <= 1;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Clock Enable Logic Stall", test_num);
            @(posedge clk);
            a <= 8'sd10; b <= 8'sd2; ce <= 1;
            @(posedge clk);
            ce <= 0;
            repeat(10) @(posedge clk);


            if (p === 16'sd20) begin
                $display("FAIL: Output updated while CE was low");
                fail_count = fail_count + 1;
            end else begin
                ce <= 1;
                repeat(5) @(posedge clk);
                #1;

                check_outputs(16'sd20);
            end
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
        testcase010();
        
        
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
        input [15:0] expected_p;
        begin
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
        $dumpvars(0,a, b, ce, clk, p);
    end

endmodule
