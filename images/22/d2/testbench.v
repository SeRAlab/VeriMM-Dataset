`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start;
    wire [2:0] channel;
    wire done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .channel(channel),
        .done(done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Normal Full Sequence Transfer", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            repeat (10) @(posedge clk);




            #1;





            check_outputs(3'b111, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Reset During Transfer", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            repeat (4) @(posedge clk);


            reset = 1;
            repeat (2) @(posedge clk);
            reset = 0;


            #1;



            check_outputs(3'b000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Idle State Check (No Start)", test_num);
            reset_dut();

            repeat (20) @(posedge clk);


            #1;



            check_outputs(3'b000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Consecutive Transfers", test_num);
            reset_dut();


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            repeat (10) @(posedge clk);


            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            repeat (10) @(posedge clk);


            #1;



            check_outputs(3'b111, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Long Start Pulse Check", test_num);
            reset_dut();

            @(posedge clk);
            start = 1;
            repeat (5) @(posedge clk);
            start = 0;

            repeat (10) @(posedge clk);

            #1;


            check_outputs(3'b111, 1'b1);
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
        input [2:0] expected_channel;
        input expected_done;
        begin
            if (expected_channel === (expected_channel ^ channel ^ expected_channel) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: channel=%h, done=%b",
                         channel, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: channel=%h, done=%b",
                         expected_channel, expected_done);
                $display("  Got:      channel=%h, done=%b",
                         channel, done);
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
        $dumpvars(0,clk, reset, start, channel, done);
    end

endmodule
