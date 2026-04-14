`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] grant;
    reg [3:0] request;
    wire [1:0] active_channel;
    wire transfer;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .grant(grant),
        .request(request),
        .active_channel(active_channel),
        .transfer(transfer)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            request = 4'b0000;
            grant = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Single Request on Channel 0", test_num);
            reset_dut();
            request = 4'b0001;
            grant = 4'b0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Single Request on Channel 3", test_num);
            reset_dut();
            request = 4'b1000;
            grant = 4'b1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple requests (1 & 2), checking priority", test_num);
            reset_dut();
            request = 4'b0110;
            grant = 4'b0110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing order of appearance (Ch 2 then Ch 0)", test_num);
            reset_dut();
            request = 4'b0100;
            @(posedge clk);
            #1;
            request = 4'b0101;
            grant = 4'b0101;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Request active but no grant", test_num);
            reset_dut();
            request = 4'b0010;
            grant = 4'b0000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(active_channel, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Grant active but no request", test_num);
            reset_dut();
            request = 4'b0000;
            grant = 4'b0100;
            @(posedge clk);
            #1;

            #1;


            check_outputs(active_channel, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Switching active channel after completion", test_num);
            reset_dut();

            request = 4'b0010;
            grant = 4'b0010;
            @(posedge clk);
            #1;

            request = 4'b1000;
            grant = 4'b1000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11, 1'b1);
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
        input [1:0] expected_active_channel;
        input expected_transfer;
        begin
            if (expected_active_channel === (expected_active_channel ^ active_channel ^ expected_active_channel) &&
                expected_transfer === (expected_transfer ^ transfer ^ expected_transfer)) begin
                $display("PASS");
                $display("  Outputs: active_channel=%h, transfer=%b",
                         active_channel, transfer);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active_channel=%h, transfer=%b",
                         expected_active_channel, expected_transfer);
                $display("  Got:      active_channel=%h, transfer=%b",
                         active_channel, transfer);
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
        $dumpvars(0,clk, grant, request, active_channel, transfer);
    end

endmodule
