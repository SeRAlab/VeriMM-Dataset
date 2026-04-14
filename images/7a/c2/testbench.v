`timescale 1ns/1ps

module shift_reg_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [15:0] pdata;
    reg rst;
    reg sin;
    wire [15:0] q;
    wire sout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_16bit dut (
        .clk(clk),
        .load(load),
        .pdata(pdata),
        .rst(rst),
        .sin(sin),
        .q(q),
        .sout(sout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        load = 0;
        pdata = 16'h0;
        sin = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic Synchronous Reset", test_num);
        reset_dut();

        #1;


        check_outputs(16'h0000, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Parallel Load", test_num);
        reset_dut();
        @(negedge clk);
        load = 1;
        pdata = 16'hA5A5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hA5A5, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Single Bit Shift Left", test_num);
        reset_dut();
        @(negedge clk);
        load = 1;
        pdata = 16'h0001;
        @(posedge clk);
        #1 load = 0;
        sin = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(16'h0003, 1'b0);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = 4;
        $display("Testcase %0d: Full Serial Fill (16 shifts)", test_num);
        reset_dut();
        @(negedge clk);
        sin = 1;
        repeat(16) @(posedge clk);
        #1;

        #1;


        check_outputs(16'hFFFF, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: MSB to Sout Propagation", test_num);
        reset_dut();
        @(negedge clk);
        load = 1;
        pdata = 16'h7FFF;
        @(posedge clk);
        #1 load = 0;
        sin = 0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(16'hFFFE, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Reset Priority over Load", test_num);
        reset_dut();
        @(negedge clk);
        rst = 1;
        load = 1;
        pdata = 16'h1234;
        @(posedge clk);
        #1;

        #1;


        check_outputs(16'h0000, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg_16bit Testbench");
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
        input expected_sout;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_sout === (expected_sout ^ sout ^ expected_sout)) begin
                $display("PASS");
                $display("  Outputs: q=%h, sout=%b",
                         q, sout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, sout=%b",
                         expected_q, expected_sout);
                $display("  Got:      q=%h, sout=%b",
                         q, sout);
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
        $dumpvars(0,clk, load, pdata, rst, sin, q, sout);
    end

endmodule
