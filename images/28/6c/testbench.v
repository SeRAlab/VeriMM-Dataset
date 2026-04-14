`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg SI;
    reg clk;
    reg rst;
    wire [3:0] PO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .SI(SI),
        .clk(clk),
        .rst(rst),
        .PO(PO)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            SI = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift in 1010", test_num);
            reset_dut();
            SI = 1; @(posedge clk);
            SI = 0; @(posedge clk);
            SI = 1; @(posedge clk);
            SI = 0; @(posedge clk);
            #1 #1;
 check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift in 1111", test_num);
            reset_dut();
            SI = 1; @(posedge clk);
            SI = 1; @(posedge clk);
            SI = 1; @(posedge clk);
            SI = 1; @(posedge clk);
            #1 #1;
 check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Over-shifting (11001)", test_num);
            reset_dut();
            SI = 1; @(posedge clk);
            SI = 1; @(posedge clk);
            SI = 0; @(posedge clk);
            SI = 0; @(posedge clk);
            SI = 1; @(posedge clk);
            #1 #1;
 check_outputs(4'b1001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift in zeros (11 -> 00)", test_num);
            reset_dut();
            SI = 1; @(posedge clk);
            SI = 1; @(posedge clk);
            SI = 0; @(posedge clk);
            SI = 0; @(posedge clk);
            #1 #1;
 check_outputs(4'b1100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset verification", test_num);
            reset_dut();
            #1 #1;
 check_outputs(4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [3:0] expected_PO;
        begin
            if (expected_PO === (expected_PO ^ PO ^ expected_PO)) begin
                $display("PASS");
                $display("  Outputs: PO=%h",
                         PO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PO=%h",
                         expected_PO);
                $display("  Got:      PO=%h",
                         PO);
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
        $dumpvars(0,SI, clk, rst, PO);
    end

endmodule
