`timescale 1ns/1ps

module shift_register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg rst;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_8bit dut (
        .clk(clk),
        .data_in(data_in),
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
        data_in = 0;
        @(negedge clk);
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Verify Synchronous Reset", test_num);
        reset_dut();
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Shift in a single '1'", test_num);
        reset_dut();
        @(negedge clk);
        data_in = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Fill register with 1s (8 shifts)", test_num);
        reset_dut();
        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk);
            data_in = 1;
        end
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    reg [7:0] pattern;
    integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Shift in pattern 0xA5", test_num);
        pattern = 8'hA5;
        reset_dut();
        for (i = 7; i >= 0; i = i - 1) begin
            @(negedge clk);
            data_in = pattern[i];
        end
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Overflow check (10 shifts)", test_num);
        reset_dut();


        @(negedge clk); data_in = 1;
        @(negedge clk); data_in = 1;
        @(negedge clk); data_in = 0;
        @(negedge clk); data_in = 0;
        @(negedge clk); data_in = 0;
        @(negedge clk); data_in = 0;
        @(negedge clk); data_in = 1;
        @(negedge clk); data_in = 1;
        @(negedge clk); data_in = 1;
        @(negedge clk); data_in = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_8bit Testbench");
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
        $dumpvars(0,clk, data_in, rst, q);
    end

endmodule
