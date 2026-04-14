`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel_num;
    reg clk;
    reg request;
    reg reset;
    wire acknowledge;
    wire busy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_num(channel_num),
        .clk(clk),
        .request(request),
        .reset(reset),
        .acknowledge(acknowledge),
        .busy(busy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            channel_num = 3'b000;
            request = 1'b0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset State Verification", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Channel 0 Request", test_num);
            reset_dut();
            channel_num = 3'd0;
            request = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Channel 7 Request", test_num);
            reset_dut();
            channel_num = 3'd7;
            request = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Request Release Verification", test_num);
            reset_dut();
            channel_num = 3'd3;
            request = 1'b1;
            @(posedge clk);
            #1;
            request = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Transfer Persistence", test_num);
            reset_dut();
            channel_num = 3'd2;
            request = 1'b1;
            @(posedge clk);
            #1;
            channel_num = 3'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b1);
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
        input expected_acknowledge;
        input expected_busy;
        begin
            if (expected_acknowledge === (expected_acknowledge ^ acknowledge ^ expected_acknowledge) &&
                expected_busy === (expected_busy ^ busy ^ expected_busy)) begin
                $display("PASS");
                $display("  Outputs: acknowledge=%b, busy=%b",
                         acknowledge, busy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acknowledge=%b, busy=%b",
                         expected_acknowledge, expected_busy);
                $display("  Got:      acknowledge=%b, busy=%b",
                         acknowledge, busy);
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
        $dumpvars(0,channel_num, clk, request, reset, acknowledge, busy);
    end

endmodule
