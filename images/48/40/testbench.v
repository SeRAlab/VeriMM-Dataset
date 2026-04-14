`timescale 1ns/1ps

module sync_up_down_counter_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg load;
    reg [7:0] load_value;
    reg rst;
    reg up_down;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_up_down_counter_8bit dut (
        .clk(clk),
        .en(en),
        .load(load),
        .load_value(load_value),
        .rst(rst),
        .up_down(up_down),
        .count(count)
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
        load_value = 0;
        up_down = 1;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Synchronous Reset Check", test_num);
        reset_dut();

        @(posedge clk);
        #1 #1;
 check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Up Counting (10 cycles)", test_num);
        reset_dut();
        en = 1;
        up_down = 1;
        repeat(10) @(posedge clk);
        #1 #1;
 check_outputs(8'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Down Counting (Wrap from 0 to 255)", test_num);
        reset_dut();
        en = 1;
        up_down = 0;
        @(posedge clk);
        #1 #1;
 check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Load Value (0xA5)", test_num);
        reset_dut();
        load = 1;
        load_value = 8'hA5;
        @(posedge clk);
        #1 load = 0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Enable Disabled Check", test_num);
        reset_dut();
        en = 1; up_down = 1;
        repeat(5) @(posedge clk);
        en = 0;
        repeat(5) @(posedge clk);
        #1 #1;
 check_outputs(8'd5);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Load Priority Over Enable/Count", test_num);
        reset_dut();
        en = 1;
        up_down = 1;
        load = 1;
        load_value = 8'h77;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h77);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Up Counting Wrap-around (255 to 0)", test_num);
        reset_dut();
        load = 1;
        load_value = 8'hFF;
        @(posedge clk);
        load = 0;
        en = 1;
        up_down = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Direction Toggle (Up 5, Down 2)", test_num);
        reset_dut();
        en = 1;
        up_down = 1;
        repeat(5) @(posedge clk);
        up_down = 0;
        repeat(2) @(posedge clk);
        #1 #1;
 check_outputs(8'd3);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Load then Down Count", test_num);
        reset_dut();
        load = 1;
        load_value = 8'h10;
        @(posedge clk);
        load = 0;
        en = 1;
        up_down = 0;
        repeat(5) @(posedge clk);
        #1 #1;
 check_outputs(8'h0B);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset Priority over Load", test_num);
        reset_dut();
        rst = 1;
        load = 1;
        load_value = 8'hAA;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_up_down_counter_8bit Testbench");
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
        input [7:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, en, load, load_value, rst, up_down, count);
    end

endmodule
