`timescale 1ns/1ps

module sd_counter_tb;

    // Testbench signals (sequential circuit)
    reg cke;
    reg clk;
    reg rst;
    wire [8:0] q;
    wire [8:0] q_bin;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_counter dut (
        .cke(cke),
        .clk(clk),
        .rst(rst),
        .q(q),
        .q_bin(q_bin)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            cke = 0;
            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Synchronous Reset Check", test_num);
            reset_dut();


            #1 #1;
 check_outputs(9'd0, 9'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Increment Check", test_num);
            reset_dut();
            cke = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(9'd1, 9'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Multi-cycle Increment (Count to 3)", test_num);
            reset_dut();
            cke = 1;
            repeat(3) @(posedge clk);

            #1 #1;
 check_outputs(9'd2, 9'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Clock Enable De-assertion Check", test_num);
            reset_dut();
            cke = 1;
            repeat(5) @(posedge clk);
            cke = 0;
            repeat(3) @(posedge clk);

            #1 #1;
 check_outputs(9'd7, 9'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Gray Code Multi-bit Transition (Count 8)", test_num);
            reset_dut();
            cke = 1;
            repeat(8) @(posedge clk);

            #1 #1;
 check_outputs(9'd12, 9'd8);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: High Value and Mid-operation Reset", test_num);
            reset_dut();
            cke = 1;
            repeat(15) @(posedge clk);

            #1 #1;
 check_outputs(9'd8, 9'd15);

            rst = 1;
            @(posedge clk);
            #1 rst = 0;
            #1;

            check_outputs(9'd0, 9'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sd_counter Testbench");
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
        input [8:0] expected_q;
        input [8:0] expected_q_bin;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_q_bin === (expected_q_bin ^ q_bin ^ expected_q_bin)) begin
                $display("PASS");
                $display("  Outputs: q=%h, q_bin=%h",
                         q, q_bin);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, q_bin=%h",
                         expected_q, expected_q_bin);
                $display("  Got:      q=%h, q_bin=%h",
                         q, q_bin);
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
        $dumpvars(0,cke, clk, rst, q, q_bin);
    end

endmodule
