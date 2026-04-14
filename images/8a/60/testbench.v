`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    reg up_down;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .en(en),
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
            up_down = 0;
            @(posedge clk);
            #1 rst = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Up-counting for 5 cycles", test_num);
            reset_dut();
            en = 1;
            up_down = 1;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Down-counting from 0 (Underflow)", test_num);
            reset_dut();
            en = 1;
            up_down = 0;
            repeat(1) @(posedge clk);
            #1 #1;
 check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Enable signal gating (pause count)", test_num);
            reset_dut();
            en = 1;
            up_down = 1;
            repeat(3) @(posedge clk);
            en = 0;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Up-counting Overflow (15 to 0)", test_num);
            reset_dut();
            en = 1;
            up_down = 1;
            repeat(16) @(posedge clk);
            #1 #1;
 check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Switching direction mid-count", test_num);
            reset_dut();
            en = 1;
            up_down = 1;
            repeat(10) @(posedge clk);
            up_down = 0;
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(4'h6);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Synchronous reset during operation", test_num);
            reset_dut();
            en = 1;
            up_down = 1;
            repeat(5) @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter Testbench");
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
        input [3:0] expected_count;
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
        $dumpvars(0,clk, en, rst, up_down, count);
    end

endmodule
