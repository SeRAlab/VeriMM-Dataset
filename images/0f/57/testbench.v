`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg request1;
    reg request2;
    reg reset;
    wire active_channel;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .request1(request1),
        .request2(request2),
        .reset(reset),
        .active_channel(active_channel),
        .transfer_complete(transfer_complete)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            request1 = 0;
            request2 = 0;
            grant1 = 0;
            grant2 = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Channel 1 Request and Grant", test_num);
            reset_dut();
            @(posedge clk);
            request1 = 1;
            grant1 = 1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Channel 2 Request and Grant", test_num);
            reset_dut();
            @(posedge clk);
            request2 = 1;
            grant2 = 1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Simultaneous Requests (Grant CH1)", test_num);
            reset_dut();
            @(posedge clk);
            request1 = 1;
            request2 = 1;
            grant1 = 1;
            grant2 = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Channel 1 Transfer Completion", test_num);
            reset_dut();
            @(posedge clk);
            request1 = 1;
            grant1 = 1;
            repeat(2) @(posedge clk);

            request1 = 0;
            grant1 = 0;
            repeat(1) @(posedge clk);

            #1 #1;
 check_outputs(0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %03d: Switch from CH1 to CH2", test_num);
            reset_dut();

            request1 = 1; grant1 = 1;
            repeat(2) @(posedge clk);

            request1 = 0; grant1 = 0;
            request2 = 1; grant2 = 1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1, 0);
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
        input expected_active_channel;
        input expected_transfer_complete;
        begin
            if (expected_active_channel === (expected_active_channel ^ active_channel ^ expected_active_channel) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: active_channel=%b, transfer_complete=%b",
                         active_channel, transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_channel=%b, transfer_complete=%b",
                         expected_active_channel, expected_transfer_complete);
                $display("  Got:      active_channel=%b, transfer_complete=%b",
                         active_channel, transfer_complete);
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
        $dumpvars(0,clk, request1, request2, reset, active_channel, transfer_complete);
    end

endmodule
