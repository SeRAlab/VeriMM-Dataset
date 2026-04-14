`timescale 1ns/1ps

module sync_up_counter_6bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    wire [5:0] q;
    wire tc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_up_counter_6bit dut (
        .clk(clk),
        .rst(rst),
        .q(q),
        .tc(tc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("\nResetting DUT...");
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying reset state", test_num);
            reset_dut();

            #1;


            check_outputs(6'd0, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Incrementing to 5", test_num);
            reset_dut();
            for(i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(6'd5, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Terminal Count at max value (63)", test_num);
            reset_dut();
            for(i = 0; i < 63; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(6'h3F, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying roll-over to 0", test_num);
            reset_dut();
            for(i = 0; i < 64; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(6'd0, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying synchronous reset mid-count", test_num);
            reset_dut();
            for(i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
            end

            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;
            #1;

            check_outputs(6'd0, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying state at 62 (just before TC)", test_num);
            reset_dut();
            for(i = 0; i < 62; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(6'h3E, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_up_counter_6bit Testbench");
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
        input [5:0] expected_q;
        input expected_tc;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_tc === (expected_tc ^ tc ^ expected_tc)) begin
                $display("PASS");
                $display("  Outputs: q=%h, tc=%b",
                         q, tc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, tc=%b",
                         expected_q, expected_tc);
                $display("  Got:      q=%h, tc=%b",
                         q, tc);
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
        $dumpvars(0,clk, rst, q, tc);
    end

endmodule
