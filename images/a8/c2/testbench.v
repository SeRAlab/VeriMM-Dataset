`timescale 1ns/1ps

module johnson_counter_8_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg rst;
    wire [7:0] johnson_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    johnson_counter_8 dut (
        .clk(clk),
        .enable(enable),
        .rst(rst),
        .johnson_count(johnson_count)
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
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Initial Reset State Check", test_num);
        reset_dut();
        #1 #1;
 check_outputs(8'b0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: First Count Transition", test_num);
        reset_dut();
        enable = 1;
        @(posedge clk);
        #1 #1;
 check_outputs(8'b0000_0001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Enable Signal Hold Test", test_num);
        reset_dut();
        enable = 1;
        @(posedge clk);
        enable = 0;
        repeat(3) @(posedge clk);
        #1 #1;
 check_outputs(8'b0000_0001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: 8-Cycle Fill (All 1s)", test_num);
        reset_dut();
        enable = 1;
        repeat(8) @(posedge clk);
        #1 #1;
 check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: 16-Cycle Full Wrap Around", test_num);
        reset_dut();
        enable = 1;
        repeat(16) @(posedge clk);
        #1 #1;
 check_outputs(8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: 12-Cycle Partial Zero-Fill", test_num);
        reset_dut();
        enable = 1;
        repeat(12) @(posedge clk);
        #1 #1;
 check_outputs(8'hF0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Mid-Sequence Reset Check", test_num);
        reset_dut();
        enable = 1;
        repeat(5) @(posedge clk);
        rst = 1;
        @(posedge clk);
        rst = 0;
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
        $display("johnson_counter_8 Testbench");
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
        input [7:0] expected_johnson_count;
        begin
            if (expected_johnson_count === (expected_johnson_count ^ johnson_count ^ expected_johnson_count)) begin
                $display("PASS");
                $display("  Outputs: johnson_count=%h",
                         johnson_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: johnson_count=%h",
                         expected_johnson_count);
                $display("  Got:      johnson_count=%h",
                         johnson_count);
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
        $dumpvars(0,clk, enable, rst, johnson_count);
    end

endmodule
