`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg ch0;
    reg ch1;
    reg ch2;
    reg ch3;
    reg clk;
    reg start;
    wire [1:0] active_channel;
    wire transfer_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .ch0(ch0),
        .ch1(ch1),
        .ch2(ch2),
        .ch3(ch3),
        .clk(clk),
        .start(start),
        .active_channel(active_channel),
        .transfer_done(transfer_done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ch0 = 0;
            ch1 = 0;
            ch2 = 0;
            ch3 = 0;
            start = 0;

            repeat (2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Initiating transfer on Channel 0", test_num);

            ch0 = 1;
            start = 1;



            repeat (100) begin
                if (transfer_done) break;
                @(posedge clk);
            end


            #2;
            #1;

            check_outputs(2'b00, 1'b1);

            start = 0;
            ch0 = 0;
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Initiating transfer on Channel 1", test_num);

            ch1 = 1;
            start = 1;

            repeat (100) begin
                if (transfer_done) break;
                @(posedge clk);
            end

            #2;
            #1;

            check_outputs(2'b01, 1'b1);

            start = 0;
            ch1 = 0;
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Initiating transfer on Channel 2", test_num);

            ch2 = 1;
            start = 1;

            repeat (100) begin
                if (transfer_done) break;
                @(posedge clk);
            end

            #2;
            #1;

            check_outputs(2'b10, 1'b1);

            start = 0;
            ch2 = 0;
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Initiating transfer on Channel 3", test_num);

            ch3 = 1;
            start = 1;

            repeat (100) begin
                if (transfer_done) break;
                @(posedge clk);
            end

            #2;
            #1;

            check_outputs(2'b11, 1'b1);

            start = 0;
            ch3 = 0;
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Check (Multiple channels CH0 and CH3)", test_num);

            ch0 = 1;
            ch3 = 1;
            start = 1;

            repeat (100) begin
                if (transfer_done) break;
                @(posedge clk);
            end

            #2;

            #1;


            check_outputs(2'b00, 1'b1);

            start = 0;
            ch0 = 0;
            ch3 = 0;
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
        input [1:0] expected_active_channel;
        input expected_transfer_done;
        begin
            if (expected_active_channel === (expected_active_channel ^ active_channel ^ expected_active_channel) &&
                expected_transfer_done === (expected_transfer_done ^ transfer_done ^ expected_transfer_done)) begin
                $display("PASS");
                $display("  Outputs: active_channel=%h, transfer_done=%b",
                         active_channel, transfer_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_channel=%h, transfer_done=%b",
                         expected_active_channel, expected_transfer_done);
                $display("  Got:      active_channel=%h, transfer_done=%b",
                         active_channel, transfer_done);
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
        $dumpvars(0,ch0, ch1, ch2, ch3, clk, start, active_channel, transfer_done);
    end

endmodule
