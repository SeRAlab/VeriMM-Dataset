`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg [3:0] request;
    reg reset;
    wire [1:0] active_channel;
    wire [3:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .ack(ack),
        .clk(clk),
        .request(request),
        .reset(reset),
        .active_channel(active_channel),
        .grant(grant)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ack = 0;
            request = 4'b0000;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Reset and Single Request (CH0)");
            test_num = test_num + 1;
            reset_dut();

            request = 4'b0001;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'd0, 4'b0001);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Round Robin Sequence (0->1->2->3)");
            test_num = test_num + 1;
            reset_dut();

            request = 4'b1111;


            @(posedge clk); #1;


            ack = 1;
            @(posedge clk); #1;
            ack = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(2'd1, 4'b0010);


            ack = 1;
            @(posedge clk); #1;
            ack = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(2'd2, 4'b0100);


            ack = 1;
            @(posedge clk); #1;
            ack = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(2'd3, 4'b1000);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Skipping Channels (0 and 2 only)");
            test_num = test_num + 1;
            reset_dut();

            request = 4'b0101;


            @(posedge clk); #1;


            ack = 1;
            @(posedge clk); #1;
            ack = 0;
            @(posedge clk); #1;


            #1;



            check_outputs(2'd2, 4'b0100);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Persistence of Grant without Ack");
            test_num = test_num + 1;
            reset_dut();

            request = 4'b0010;
            @(posedge clk); #1;


            repeat(3) @(posedge clk);
            #1;


            #1;



            check_outputs(2'd1, 4'b0010);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Wrap Around (3 back to 0)");
            test_num = test_num + 1;
            reset_dut();


            request = 4'b1111;
            repeat(3) begin
                @(posedge clk); #1;
                ack = 1;
                @(posedge clk); #1;
                ack = 0;
            end


            @(posedge clk); #1;


            ack = 1;
            @(posedge clk); #1;
            ack = 0;
            @(posedge clk); #1;


            #1;



            check_outputs(2'd0, 4'b0001);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Idle to Request Transition");
            test_num = test_num + 1;
            reset_dut();

            request = 4'b0000;
            repeat(5) @(posedge clk);

            request = 4'b1000;
            @(posedge clk); #1;

            #1;


            check_outputs(2'd3, 4'b1000);
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
        input [1:0] expected_active_channel;
        input [3:0] expected_grant;
        begin
            if (expected_active_channel === (expected_active_channel ^ active_channel ^ expected_active_channel) &&
                expected_grant === (expected_grant ^ grant ^ expected_grant)) begin
                $display("PASS");
                $display("  Outputs: active_channel=%h, grant=%h",
                         active_channel, grant);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_channel=%h, grant=%h",
                         expected_active_channel, expected_grant);
                $display("  Got:      active_channel=%h, grant=%h",
                         active_channel, grant);
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
        $dumpvars(0,ack, clk, request, reset, active_channel, grant);
    end

endmodule
