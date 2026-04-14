`timescale 1ns/1ps

module dcfifo_fefifo_tb;

    // Testbench signals (sequential circuit)
    reg aclr;
    reg clock;
    reg rreq;
    reg usedw_in;
    reg wreq;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dcfifo_fefifo dut (
        .aclr(aclr),
        .clock(clock),
        .rreq(rreq),
        .usedw_in(usedw_in),
        .wreq(wreq),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        aclr = 0;
        forever #5 aclr = ~aclr;
    end

        task reset_dut;

        begin
            aclr = 1;
            rreq = 0;
            wreq = 0;
            usedw_in = 0;
            #20;
            aclr = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Partially Full (1 Word)", test_num);
            reset_dut();
            @(posedge clock);
            usedw_in = 1;
            wreq = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Maximum Capacity (Full)", test_num);
            reset_dut();
            @(posedge clock);
            usedw_in = MAX_USED;
            wreq = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Full to Not-Full Transition", test_num);
            reset_dut();
            usedw_in = MAX_USED;
            @(posedge clock);
            #2;

            rreq = 1;
            usedw_in = MAX_USED - 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Empty to Not-Empty Transition", test_num);
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0);

            @(posedge clock);
            wreq = 1;
            usedw_in = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dcfifo_fefifo Testbench");
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
        input expected_empty;
        input expected_full;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b",
                         empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b",
                         expected_empty, expected_full);
                $display("  Got:      empty=%b, full=%b",
                         empty, full);
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
        $dumpvars(0,aclr, clock, rreq, usedw_in, wreq, empty, full);
    end

endmodule
