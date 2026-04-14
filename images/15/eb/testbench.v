`timescale 1ns/1ps

module pcie_sm_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg clk;
    reg done;
    reg rst;
    reg start;
    wire [1:0] current_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_sm dut (
        .ack(ack),
        .clk(clk),
        .done(done),
        .rst(rst),
        .start(start),
        .current_state(current_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            ack = 0;
            done = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Full Cycle (IDLE->REQ->RESP->IDLE)");
            reset_dut();


            start = 1;
            @(posedge clk);
            #1 start = 0;


            ack = 1;
            @(posedge clk);
            #1 ack = 0;


            done = 1;
            @(posedge clk);
            #1 done = 0;


            @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Transition to REQUEST");
            reset_dut();

            start = 1;
            @(posedge clk);
            #1 start = 0;

            @(posedge clk);
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Transition to RESPONSE");
            reset_dut();

            start = 1;
            @(posedge clk);
            #1 start = 0;
            ack = 1;
            @(posedge clk);
            #1 ack = 0;

            @(posedge clk);
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Reset from REQUEST state");
            reset_dut();

            start = 1;
            @(posedge clk);
            #1 start = 0;


            rst = 1;
            @(posedge clk);
            #1 rst = 0;

            @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Ack ignored in IDLE");
            reset_dut();

            ack = 1;
            @(posedge clk);
            #1 ack = 0;

            @(posedge clk);
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Stay in RESPONSE until done");
            reset_dut();

            start = 1;
            @(posedge clk);
            #1 start = 0;
            ack = 1;
            @(posedge clk);
            #1 ack = 0;


            repeat(3) @(posedge clk);

            #1;


            check_outputs(2'b10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_sm Testbench");
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
        input [1:0] expected_current_state;
        begin
            if (expected_current_state === (expected_current_state ^ current_state ^ expected_current_state)) begin
                $display("PASS");
                $display("  Outputs: current_state=%h",
                         current_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_state=%h",
                         expected_current_state);
                $display("  Got:      current_state=%h",
                         current_state);
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
        $dumpvars(0,ack, clk, done, rst, start, current_state);
    end

endmodule
