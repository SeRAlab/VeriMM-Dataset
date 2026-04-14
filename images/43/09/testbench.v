`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg clk;
    reg [15:0] d;
    reg [1:0] we;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .d(d),
        .we(we),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        a = 8'h0;
        d = 16'h0;
        we = 2'b0;
        @(negedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Full Word Write and Read", test_num);
        reset_dut();
        @(negedge clk);
        a = 8'h01; d = 16'hA5A5; we = 2'b11;
        @(negedge clk);
        a = 8'h01; we = 2'b00;
        @(negedge clk);
        #1;

        check_outputs(16'hA5A5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Address Write/Read (0xFF)", test_num);
        reset_dut();
        @(negedge clk);
        a = 8'hFF; d = 16'h1234; we = 2'b11;
        @(negedge clk);
        a = 8'hFF; we = 2'b00;
        @(negedge clk);
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Lower Byte Write Enable (we[0])", test_num);
        reset_dut();

        @(negedge clk);
        a = 8'h10; d = 16'hFFFF; we = 2'b11;

        @(negedge clk);
        a = 8'h10; d = 16'h0055; we = 2'b01;

        @(negedge clk);
        a = 8'h10; we = 2'b00;
        @(negedge clk);
        #1;

        check_outputs(16'hFF55);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Upper Byte Write Enable (we[1])", test_num);
        reset_dut();

        @(negedge clk);
        a = 8'h20; d = 16'h0000; we = 2'b11;

        @(negedge clk);
        a = 8'h20; d = 16'hAA00; we = 2'b10;

        @(negedge clk);
        a = 8'h20; we = 2'b00;
        @(negedge clk);
        #1;

        check_outputs(16'hAA00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Write Disable Verification", test_num);
        reset_dut();

        @(negedge clk);
        a = 8'h30; d = 16'h5555; we = 2'b11;

        @(negedge clk);
        a = 8'h30; d = 16'hAAAA; we = 2'b00;

        @(negedge clk);
        a = 8'h30; we = 2'b00;
        @(negedge clk);
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Address Independence (Multiple Writes)", test_num);
        reset_dut();

        @(negedge clk);
        a = 8'h40; d = 16'h1111; we = 2'b11;

        @(negedge clk);
        a = 8'h41; d = 16'h2222; we = 2'b11;

        @(negedge clk);
        a = 8'h40; we = 2'b00;
        @(negedge clk);
        #1;

        check_outputs(16'h1111);
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
        input [15:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,a, clk, d, we, q);
    end

endmodule
