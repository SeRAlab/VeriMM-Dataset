`timescale 1ns/1ps

module counter_sync_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg load;
    reg [15:0] load_val;
    reg rst_n;
    wire [15:0] count;
    wire o_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_sync_16bit dut (
        .clk(clk),
        .en(en),
        .load(load),
        .load_val(load_val),
        .rst_n(rst_n),
        .count(count),
        .o_en(o_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst_n = 0;
            en = 0;
            load = 0;
            load_val = 16'h0;
            repeat(2) @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset State Check", test_num);
            reset_dut();


            #1;
            #1;

            check_outputs(16'h0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Value Check", test_num);
            reset_dut();

            @(posedge clk);
            #1;
            load = 1;
            load_val = 16'hA5A5;

            @(posedge clk);
            #1;
            load = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hA5A5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Increment Check", test_num);
            reset_dut();


            @(posedge clk); #1;
            load = 1; load_val = 16'h000A;
            @(posedge clk); #1;
            load = 0; en = 1;


            repeat(5) @(posedge clk);

            #1;
            #1;

            check_outputs(16'h000F, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Counter Hold (en=0) Check", test_num);
            reset_dut();

            @(posedge clk); #1;
            load = 1; load_val = 16'h0010;
            @(posedge clk); #1;
            load = 0; en = 1;

            repeat(3) @(posedge clk);
            #1; en = 0;

            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0013, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load Priority Over Enable Check", test_num);
            reset_dut();

            @(posedge clk); #1;
            en = 1;
            repeat(5) @(posedge clk);

            #1;
            load = 1;
            load_val = 16'h7777;
            en = 1;

            @(posedge clk); #1;
            load = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(16'h7777, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Counter Rollover Check", test_num);
            reset_dut();

            @(posedge clk); #1;
            load = 1; load_val = 16'hFFFE;
            @(posedge clk); #1;
            load = 0; en = 1;

            repeat(2) @(posedge clk);

            #1;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_sync_16bit Testbench");
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
        input [15:0] expected_count;
        input expected_o_en;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_o_en === (expected_o_en ^ o_en ^ expected_o_en)) begin
                $display("PASS");
                $display("  Outputs: count=%h, o_en=%b",
                         count, o_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, o_en=%b",
                         expected_count, expected_o_en);
                $display("  Got:      count=%h, o_en=%b",
                         count, o_en);
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
        $dumpvars(0,clk, en, load, load_val, rst_n, count, o_en);
    end

endmodule
