`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] request;
    reg rst;
    wire [3:0] grant;
    wire transfer_in_progress;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .request(request),
        .rst(rst),
        .grant(grant),
        .transfer_in_progress(transfer_in_progress)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            request = 4'b0000;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Idle State");
            reset_dut();

            #1;


            check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Request Channel 0");
            reset_dut();
            request = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Single Request Channel 3");
            reset_dut();
            request = 4'b1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Simultaneous Requests (0, 1, and 2)");
            reset_dut();
            request = 4'b0111;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0001, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Transfer Stickiness (Non-preemptive)");
            reset_dut();


            request = 4'b0100;
            @(posedge clk);
            #1;


            request = 4'b0101;
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(4'b0100, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Sequential Transfers");
            reset_dut();


            request = 4'b0010;
            @(posedge clk);
            #1;


            request = 4'b0000;
            @(posedge clk);
            #1;
            request = 4'b1000;
            @(posedge clk);
            #1;


            #1;



            check_outputs(4'b1000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Priority Arbitration (2 vs 3)");
            reset_dut();
            request = 4'b1100;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'b0100, 1'b1);
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
        input [3:0] expected_grant;
        input expected_transfer_in_progress;
        begin
            if (expected_grant === (expected_grant ^ grant ^ expected_grant) &&
                expected_transfer_in_progress === (expected_transfer_in_progress ^ transfer_in_progress ^ expected_transfer_in_progress)) begin
                $display("PASS");
                $display("  Outputs: grant=%h, transfer_in_progress=%b",
                         grant, transfer_in_progress);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: grant=%h, transfer_in_progress=%b",
                         expected_grant, expected_transfer_in_progress);
                $display("  Got:      grant=%h, transfer_in_progress=%b",
                         grant, transfer_in_progress);
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
        $dumpvars(0,clk, request, rst, grant, transfer_in_progress);
    end

endmodule
