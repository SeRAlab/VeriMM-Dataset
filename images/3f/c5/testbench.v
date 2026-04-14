`timescale 1ns/1ps

module wifi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg request;
    wire connected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_controller dut (
        .clk(clk),
        .request(request),
        .connected(connected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        request = 0;
        repeat(2) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %03d: Basic Connection", test_num);
        reset_dut();
        request = 1;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %03d: Disconnection", test_num);
        reset_dut();
        request = 1;
        @(posedge clk);
        #1;
        request = 0;
        repeat(2) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %03d: Re-connection", test_num);
        reset_dut();

        request = 1; @(posedge clk); #1;
        request = 0; @(posedge clk); #1;

        request = 1; @(posedge clk); #1;
        repeat(1) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %03d: Stability (Sustained High)", test_num);
        reset_dut();
        request = 1;
        repeat(10) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %03d: Idle Check", test_num);
        reset_dut();
        request = 0;
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_controller Testbench");
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
        input expected_connected;
        begin
            if (expected_connected === (expected_connected ^ connected ^ expected_connected)) begin
                $display("PASS");
                $display("  Outputs: connected=%b",
                         connected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: connected=%b",
                         expected_connected);
                $display("  Got:      connected=%b",
                         connected);
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
        $dumpvars(0,clk, request, connected);
    end

endmodule
