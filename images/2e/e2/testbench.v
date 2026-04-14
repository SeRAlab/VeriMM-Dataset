`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg channel1_req;
    reg channel2_req;
    reg clk;
    reg reset;
    wire channel1_done;
    wire channel2_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel1_req(channel1_req),
        .channel2_req(channel2_req),
        .clk(clk),
        .reset(reset),
        .channel1_done(channel1_done),
        .channel2_done(channel2_done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            channel1_req = 0;
            channel2_req = 0;
            repeat(2) @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Channel 1 Single Request", test_num);
            reset_dut();

            @(posedge clk);
            channel1_req = 1;


            fork
                begin : wait_done1
                    wait(channel1_done == 1);
                    disable timeout1;
                end
                begin : timeout1
                    repeat(50) @(posedge clk);
                    $display("Timeout waiting for channel1_done");
                    disable wait_done1;
                end
            join

            channel1_req = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Channel 2 Single Request", test_num);
            reset_dut();

            @(posedge clk);
            channel2_req = 1;

            fork
                begin : wait_done2
                    wait(channel2_done == 1);
                    disable timeout2;
                end
                begin : timeout2
                    repeat(50) @(posedge clk);
                    $display("Timeout waiting for channel2_done");
                    disable wait_done2;
                end
            join

            channel2_req = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Simultaneous Channel 1 and 2 Requests", test_num);
            reset_dut();

            @(posedge clk);
            channel1_req = 1;
            channel2_req = 1;


            fork
                begin : wait_both_done
                    wait(channel1_done == 1 && channel2_done == 1);
                    disable timeout3;
                end
                begin : timeout3
                    repeat(100) @(posedge clk);
                    $display("Timeout waiting for both done signals");
                    disable wait_both_done;
                end
            join

            channel1_req = 0;
            channel2_req = 0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Idle State Check", test_num);
            reset_dut();


            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Sequential Requests", test_num);
            reset_dut();


            @(posedge clk);
            channel1_req = 1;
            wait(channel1_done == 1);
            channel1_req = 0;


            @(posedge clk);
            channel2_req = 1;
            wait(channel2_done == 1);
            channel2_req = 0;

            repeat(2) @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
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
        input expected_channel1_done;
        input expected_channel2_done;
        begin
            if (expected_channel1_done === (expected_channel1_done ^ channel1_done ^ expected_channel1_done) &&
                expected_channel2_done === (expected_channel2_done ^ channel2_done ^ expected_channel2_done)) begin
                $display("PASS");
                $display("  Outputs: channel1_done=%b, channel2_done=%b",
                         channel1_done, channel2_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: channel1_done=%b, channel2_done=%b",
                         expected_channel1_done, expected_channel2_done);
                $display("  Got:      channel1_done=%b, channel2_done=%b",
                         channel1_done, channel2_done);
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
        $dumpvars(0,channel1_req, channel2_req, clk, reset, channel1_done, channel2_done);
    end

endmodule
