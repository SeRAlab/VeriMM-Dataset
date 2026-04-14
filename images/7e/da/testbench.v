`timescale 1ns/1ps

module register_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    reg en;
    reg rst;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_16bit dut (
        .clk(clk),
        .data(data),
        .en(en),
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
        @(negedge clk);
        rst = 1;
        en = 0;
        data = 16'h0000;
        @(negedge clk);
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %03d: Checking initial reset state...", test_num);
        reset_dut();

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %03d: Loading data with enable=1...", test_num);
        reset_dut();
        @(negedge clk);
        en = 1;
        data = 16'hA5A5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hA5A5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %03d: Verifying data does not change when enable=0...", test_num);
        reset_dut();

        @(negedge clk);
        en = 1;
        data = 16'h1234;
        @(posedge clk);

        @(negedge clk);
        en = 0;
        data = 16'hFFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %03d: Multiple successive writes...", test_num);
        reset_dut();
        @(negedge clk);
        en = 1;
        data = 16'h0001;
        @(posedge clk);
        @(negedge clk);
        data = 16'h0002;
        @(posedge clk);
        @(negedge clk);
        data = 16'h8000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %03d: Checking synchronous reset priority over enable...", test_num);
        reset_dut();
        @(negedge clk);
        en = 1;
        data = 16'hFFFF;
        rst = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000);
        @(negedge clk);
        rst = 0;
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %03d: Loading maximum 16-bit value...", test_num);
        reset_dut();
        @(negedge clk);
        en = 1;
        data = 16'hFFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_16bit Testbench");
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
        $dumpvars(0,clk, data, en, rst, q);
    end

endmodule
