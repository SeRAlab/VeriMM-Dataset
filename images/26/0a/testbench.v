`timescale 1ns/1ps

module pcie_request_handler_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg req;
    wire busy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_request_handler dut (
        .ack(ack),
        .clk(clk),
        .req(req),
        .busy(busy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        req <= 0;
        ack <= 0;
        @(posedge clk);
        ack <= 1;
        @(posedge clk);
        ack <= 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Single Request pulse", test_num);
        reset_dut();
        req <= 1;
        @(posedge clk);
        req <= 0;
        repeat(2) @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Request followed by Acknowledge", test_num);
        reset_dut();
        req <= 1;
        @(posedge clk);
        req <= 0;
        @(posedge clk);
        ack <= 1;
        @(posedge clk);
        ack <= 0;
        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Hold Request High", test_num);
        reset_dut();
        req <= 1;
        repeat(5) @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Acknowledge while Idle", test_num);
        reset_dut();
        ack <= 1;
        repeat(3) @(posedge clk);
        ack <= 0;
        @(posedge clk);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Multiple Sequential Requests", test_num);
        reset_dut();

        req <= 1; @(posedge clk); req <= 0;
        ack <= 1; @(posedge clk); ack <= 0;

        req <= 1; @(posedge clk); req <= 0;
        @(posedge clk);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Simultaneous Req and Ack", test_num);
        reset_dut();
        req <= 1;
        ack <= 1;
        @(posedge clk);
        req <= 0;
        ack <= 0;
        @(posedge clk);
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
        $display("pcie_request_handler Testbench");
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
        input expected_busy;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy)) begin
                $display("PASS");
                $display("  Outputs: busy=%b",
                         busy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b",
                         expected_busy);
                $display("  Got:      busy=%b",
                         busy);
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
        $dumpvars(0,ack, clk, req, busy);
    end

endmodule
