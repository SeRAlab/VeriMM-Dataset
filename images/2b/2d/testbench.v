`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg channel0_req;
    reg channel0_valid;
    reg channel1_req;
    reg channel1_valid;
    reg clk;
    reg rst;
    wire channel0_grant;
    wire channel1_grant;
    wire transfer_complete;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel0_req(channel0_req),
        .channel0_valid(channel0_valid),
        .channel1_req(channel1_req),
        .channel1_valid(channel1_valid),
        .clk(clk),
        .rst(rst),
        .channel0_grant(channel0_grant),
        .channel1_grant(channel1_grant),
        .transfer_complete(transfer_complete)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        channel0_req = 0;
        channel0_valid = 0;
        channel1_req = 0;
        channel1_valid = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Channel 0 Single Request", test_num);
        reset_dut();

        channel0_req = 1;
        channel0_valid = 1;


        wait(channel0_grant === 1);
        @(posedge clk);


        wait(transfer_complete === 1);
        @(posedge clk);



        #1;




        check_outputs(0, 0, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Channel 1 Single Request (Ch0 Idle)", test_num);
        reset_dut();

        channel1_req = 1;
        channel1_valid = 1;

        wait(channel1_grant === 1);
        @(posedge clk);

        wait(transfer_complete === 1);
        @(posedge clk);

        #1;


        check_outputs(0, 0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Simultaneous Requests (Priority Test)", test_num);
        reset_dut();

        channel0_req = 1;
        channel0_valid = 1;
        channel1_req = 1;
        channel1_valid = 1;


        @(posedge clk);
        #1;
        if (channel0_grant === 1 && channel1_grant === 0) begin
            $display("Priority Correct: Channel 0 granted.");
        end else begin
            $display("Priority Error: Channel 0 grant=%b, Channel 1 grant=%b", channel0_grant, channel1_grant);
        end


        wait(transfer_complete === 1);
        @(posedge clk);


        #1;



        check_outputs(0, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Priority Contention", test_num);
        reset_dut();


        channel1_req = 1;
        channel1_valid = 1;
        @(posedge clk);
        wait(channel1_grant === 1);


        channel0_req = 1;
        channel0_valid = 1;

        repeat(2) @(posedge clk);



        if (channel1_grant === 1) $display("Channel 1 finishing current transfer...");

        wait(transfer_complete === 1);
        @(posedge clk);
        #1;


        #1;



        check_outputs(1, 0, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Reset during Transfer", test_num);
        reset_dut();

        channel0_req = 1;
        channel0_valid = 1;
        wait(channel0_grant === 1);


        repeat(2) @(posedge clk);
        rst = 1;
        @(posedge clk);
        rst = 0;
        #1;


        #1;



        check_outputs(0, 0, 0);
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
        input expected_channel0_grant;
        input expected_channel1_grant;
        input expected_transfer_complete;
        begin
            if (expected_channel0_grant === (expected_channel0_grant ^ channel0_grant ^ expected_channel0_grant) &&
                expected_channel1_grant === (expected_channel1_grant ^ channel1_grant ^ expected_channel1_grant) &&
                expected_transfer_complete === (expected_transfer_complete ^ transfer_complete ^ expected_transfer_complete)) begin
                $display("PASS");
                $display("  Outputs: channel0_grant=%b, channel1_grant=%b, transfer_complete=%b",
                         channel0_grant, channel1_grant, transfer_complete);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: channel0_grant=%b, channel1_grant=%b, transfer_complete=%b",
                         expected_channel0_grant, expected_channel1_grant, expected_transfer_complete);
                $display("  Got:      channel0_grant=%b, channel1_grant=%b, transfer_complete=%b",
                         channel0_grant, channel1_grant, transfer_complete);
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
        $dumpvars(0,channel0_req, channel0_valid, channel1_req, channel1_valid, clk, rst, channel0_grant, channel1_grant, transfer_complete);
    end

endmodule
