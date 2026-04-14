`timescale 1ns/1ps

module counter10bit_up_down_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    reg up_down;
    wire [9:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter10bit_up_down dut (
        .clk(clk),
        .en(en),
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
            rst = 1;
            en = 0;
            up_down = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Up Counting (10 cycles)", test_num);
            reset_dut();
            en = 1;
            up_down = 1;
            repeat(10) @(posedge clk);
            #1 #1;
 check_outputs(10'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Underflow (0 to -1)", test_num);
            reset_dut();
            en = 1;
            up_down = 0;
            repeat(1) @(posedge clk);
            #1 #1;
 check_outputs(10'h3FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable Control (Count 5, Disable 5)", test_num);
            reset_dut();
            en = 1;
            up_down = 1;
            repeat(5) @(posedge clk);
            en = 0;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(10'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-stream Direction Switch", test_num);
            reset_dut();
            en = 1;
            up_down = 1;
            repeat(15) @(posedge clk);
            up_down = 0;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(10'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow Wrap Around (1024 cycles)", test_num);
            reset_dut();
            en = 1;
            up_down = 1;
            repeat(1024) @(posedge clk);
            #1 #1;
 check_outputs(10'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable and Direction change", test_num);
            reset_dut();
            en = 1;
            up_down = 1;
            repeat(10) @(posedge clk);
            en = 0;
            up_down = 0;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(10'd10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Long Down Count", test_num);
            reset_dut();
            en = 1;
            up_down = 0;
            repeat(100) @(posedge clk);

            #1 #1;
 check_outputs(10'd924);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter10bit_up_down Testbench");
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
        input [9:0] expected_q;
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
        $dumpvars(0,clk, en, rst, up_down, q);
    end

endmodule
