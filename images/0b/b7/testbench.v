`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] active;
    reg clk;
    reg [3:0] request;
    reg reset;
    wire [3:0] grant;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .active(active),
        .clk(clk),
        .request(request),
        .reset(reset),
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
            active = 4'b0000;
            request = 4'b0000;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Single request on active Channel 0");
            reset_dut();
            active = 4'b0001;
            request = 4'b0001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Request on inactive Channel 1");
            reset_dut();
            active = 4'b1101;
            request = 4'b0010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Priority check (Multiple active requests)");
            reset_dut();
            active = 4'b1111;
            request = 4'b1111;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0001);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Priority check (High priority inactive)");
            reset_dut();
            active = 4'b1110;
            request = 4'b0011;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Single request on active Channel 3");
            reset_dut();
            active = 4'b1000;
            request = 4'b1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Active channels with no requests");
            reset_dut();
            active = 4'b1111;
            request = 4'b0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning Testcase 007: Reset behavior check");
            reset_dut();
            active = 4'b1111;
            request = 4'b0100;
            @(posedge clk);
            #1;
            reset = 1;
            @(posedge clk);
            #2;
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
        input [3:0] expected_grant;
        begin
            if (expected_grant === (expected_grant ^ grant ^ expected_grant)) begin
                $display("PASS");
                $display("  Outputs: grant=%h",
                         grant);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: grant=%h",
                         expected_grant);
                $display("  Got:      grant=%h",
                         grant);
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
        $dumpvars(0,active, clk, request, reset, grant);
    end

endmodule
