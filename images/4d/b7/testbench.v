`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [5:0] b;
    reg ce;
    reg clk;
    wire [13:0] p;

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
            a <= 0;
            b <= 0;
            ce <= 0;
            @(posedge clk);
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            a <= 8'd10;
            b <= 6'd5;
            ce <= 1'b1;
            repeat (2) @(posedge clk);
            #1;
            $display("Test %0d: 10 * 5", test_num);
            #1;

            check_outputs(14'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            a <= 8'hFF;
            b <= 6'h3F;
            ce <= 1'b1;
            repeat (2) @(posedge clk);
            #1;
            $display("Test %0d: 255 * 63", test_num);
            #1;

            check_outputs(14'd16065);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            a <= 8'd128;
            b <= 6'd0;
            ce <= 1'b1;
            repeat (2) @(posedge clk);
            #1;
            $display("Test %0d: 128 * 0", test_num);
            #1;

            check_outputs(14'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            a <= 8'd64;
            b <= 6'd32;
            ce <= 1'b1;
            repeat (2) @(posedge clk);
            #1;
            $display("Test %0d: 64 * 32", test_num);
            #1;

            check_outputs(14'd2048);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk);
            a <= 8'd5;
            b <= 6'd5;
            ce <= 1'b1;
            repeat (2) @(posedge clk);
            #1;
            if (p !== 14'd25) begin
                $display("Setup failed for Test 005");
            end


            @(posedge clk);
            a <= 8'd10;
            b <= 6'd10;
            ce <= 1'b0;
            repeat (3) @(posedge clk);
            #1;
            $display("Test %0d: Clock Enable check (should hold 25)", test_num);
            #1;

            check_outputs(14'd25);
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
        input [13:0] expected_p;
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
