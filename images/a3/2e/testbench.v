`timescale 1ns/1ps

module bidir_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg up_down;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bidir_counter dut (
        .clk(clk),
        .rst(rst),
        .up_down(up_down),
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
        up_down = 1;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Simple Count Up (10 steps)", test_num);
        reset_dut();
        up_down = 1;
        repeat(10) @(posedge clk);
        #1 #1;
 check_outputs(8'd10);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Simple Count Down (Underflow from 0)", test_num);
        reset_dut();
        up_down = 0;
        repeat(5) @(posedge clk);

        #1 #1;
 check_outputs(8'hFB);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Bidirectional sequence (Up 10, Down 4)", test_num);
        reset_dut();
        up_down = 1;
        repeat(10) @(posedge clk);
        up_down = 0;
        repeat(4) @(posedge clk);
        #1 #1;
 check_outputs(8'd6);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Overflow test (Count up 257 times)", test_num);
        reset_dut();
        up_down = 1;
        repeat(257) @(posedge clk);

        #1 #1;
 check_outputs(8'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Reset priority check", test_num);
        reset_dut();
        up_down = 1;
        repeat(5) @(posedge clk);
        rst = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h00);
        rst = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bidir_counter Testbench");
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, rst, up_down, q);
    end

endmodule
