`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] sel;
    reg start;
    wire [3:0] active_channel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .reset(reset),
        .sel(sel),
        .start(start),
        .active_channel(active_channel)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            sel = 4'b0000;
            start = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Channel 1", test_num);
            reset_dut();
            @(negedge clk);
            sel = 4'b0001;
            start = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Channel 4", test_num);
            reset_dut();
            @(negedge clk);
            sel = 4'b1000;
            start = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Start signal gating (start=0)", test_num);
            reset_dut();
            @(negedge clk);
            sel = 4'b0101;
            start = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Channel Updates", test_num);
            reset_dut();

            @(negedge clk);
            sel = 4'b0010;
            start = 1;
            @(posedge clk);

            @(negedge clk);
            sel = 4'b0100;
            start = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hold value when start is low", test_num);
            reset_dut();

            @(negedge clk);
            sel = 4'b1111;
            start = 1;
            @(posedge clk);

            @(negedge clk);
            sel = 4'b0000;
            start = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b1111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset during operation", test_num);
            reset_dut();
            @(negedge clk);
            sel = 4'b1010;
            start = 1;
            @(posedge clk);
            #1 reset = 1;
            #5;
            #1;

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
        $display("dma_controller Testbench");
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
        input [3:0] expected_active_channel;
        begin
            if (expected_active_channel === (expected_active_channel ^ active_channel ^ expected_active_channel)) begin
                $display("PASS");
                $display("  Outputs: active_channel=%h",
                         active_channel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_channel=%h",
                         expected_active_channel);
                $display("  Got:      active_channel=%h",
                         active_channel);
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
        $dumpvars(0,clk, reset, sel, start, active_channel);
    end

endmodule
