`timescale 1ns/1ps

module counter6bit_down_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg load;
    reg [5:0] load_val;
    reg rst;
    wire [5:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter6bit_down dut (
        .clk(clk),
        .en(en),
        .load(load),
        .load_val(load_val),
        .rst(rst),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        en = 0;
        load = 0;
        load_val = 0;
        @(posedge clk);
        #1;
        rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Basic Reset", test_num);
        reset_dut();


        #1;



        check_outputs(6'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Load Value (6'h3F)", test_num);
        reset_dut();
        load = 1;
        load_val = 6'h3F;
        @(posedge clk);
        #1;
        load = 0;
        #1;

        check_outputs(6'h3F);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Simple Decrement (5 -> 4 -> 3)", test_num);
        reset_dut();

        load = 1;
        load_val = 6'h05;
        @(posedge clk);
        #1;
        load = 0;
        en = 1;

        repeat(2) @(posedge clk);
        #1;
        en = 0;
        #1;

        check_outputs(6'h03);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Enable Inactive (Value should hold)", test_num);
        reset_dut();
        load = 1;
        load_val = 6'h1A;
        @(posedge clk);
        #1;
        load = 0;
        en = 0;
        repeat(3) @(posedge clk);
        #1;
        #1;

        check_outputs(6'h1A);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Underflow (1 -> 0 -> 63)", test_num);
        reset_dut();
        load = 1;
        load_val = 6'h01;
        @(posedge clk);
        #1;
        load = 0;
        en = 1;
        repeat(2) @(posedge clk);
        #1;
        en = 0;
        #1;

        check_outputs(6'h3F);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Load Priority Over Enable", test_num);
        reset_dut();
        load = 1;
        load_val = 6'h20;
        @(posedge clk);
        #1;

        en = 1;
        load = 1;
        load_val = 6'h0A;
        @(posedge clk);
        #1;
        load = 0;
        en = 0;
        #1;

        check_outputs(6'h0A);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Continuous Count (10 steps)", test_num);
        reset_dut();
        load = 1;
        load_val = 6'd20;
        @(posedge clk);
        #1;
        load = 0;
        en = 1;
        repeat(10) @(posedge clk);
        #1;
        en = 0;
        #1;

        check_outputs(6'd10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter6bit_down Testbench");
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
        input [5:0] expected_q;
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
        $dumpvars(0,clk, en, load, load_val, rst, q);
    end

endmodule
