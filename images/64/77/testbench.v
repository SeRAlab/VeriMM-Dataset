`timescale 1ns/1ps

module counter_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg down;
    reg enable;
    reg rst;
    reg up;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_8bit dut (
        .clk(clk),
        .down(down),
        .enable(enable),
        .rst(rst),
        .up(up),
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
        enable = 0;
        up = 0;
        down = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying reset clears counter", test_num);
        reset_dut();
        #1 #1;
 check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Incrementing 10 times", test_num);
        reset_dut();
        enable = 1;
        up = 1;
        down = 0;
        repeat(10) @(posedge clk);
        #1 #1;
 check_outputs(8'd10);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Increment to 20 then Decrement to 15", test_num);
        reset_dut();
        enable = 1;
        up = 1;
        down = 0;
        repeat(20) @(posedge clk);
        up = 0;
        down = 1;
        repeat(5) @(posedge clk);
        #1 #1;
 check_outputs(8'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify counter stays still when enable is low", test_num);
        reset_dut();
        enable = 1;
        up = 1;
        repeat(5) @(posedge clk);
        enable = 0;
        repeat(10) @(posedge clk);
        #1 #1;
 check_outputs(8'd5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying roll-over (255 -> 0)", test_num);
        reset_dut();
        enable = 1;
        up = 1;
        down = 0;
        repeat(255) @(posedge clk);
        @(posedge clk);
        #1 #1;
 check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying roll-under (0 -> 255)", test_num);
        reset_dut();
        enable = 1;
        up = 0;
        down = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Counter holds when enable is high but up/down both low", test_num);
        reset_dut();
        enable = 1;
        up = 1;
        repeat(10) @(posedge clk);
        up = 0;
        down = 0;
        repeat(5) @(posedge clk);
        #1 #1;
 check_outputs(8'd10);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Checking behavior when both Up and Down are high", test_num);
        reset_dut();
        enable = 1;
        up = 1;
        down = 1;
        @(posedge clk);




        #1 #1;
 check_outputs(8'd1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,clk, down, enable, rst, up, count);
    end

endmodule
