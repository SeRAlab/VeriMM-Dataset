`timescale 1ns/1ps

module sync_ring_counter_10bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [9:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_ring_counter_10bit dut (
        .clk(clk),
        .en(en),
        .rst(rst),
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
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(10'b0000000001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Shift", test_num);
            reset_dut();
            en = 1;
            @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(10'b0000000010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift 5 Times", test_num);
            reset_dut();
            en = 1;
            repeat(5) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(10'b0000100000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full 10-bit Rotation", test_num);
            reset_dut();
            en = 1;
            repeat(10) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(10'b0000000001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable/Disable Toggle", test_num);
            reset_dut();
            en = 1;
            repeat(2) @(posedge clk);
            #1;
            en = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(10'b0000000100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift to MSB", test_num);
            reset_dut();
            en = 1;
            repeat(9) @(posedge clk);
            #1;
            en = 0;
            #1;

            check_outputs(10'b1000000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset During Operation", test_num);
            reset_dut();
            en = 1;
            repeat(4) @(posedge clk);
            #1;
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            #1;

            check_outputs(10'b0000000001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_ring_counter_10bit Testbench");
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
        input [9:0] expected_count;
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
        $dumpvars(0,clk, en, rst, count);
    end

endmodule
