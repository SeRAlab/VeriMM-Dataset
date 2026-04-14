`timescale 1ns/1ps

module bluetooth_state_machine_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg connecting_done;
    reg disconnect;
    reg reset;
    reg start;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bluetooth_state_machine dut (
        .clk(clk),
        .connecting_done(connecting_done),
        .disconnect(disconnect),
        .reset(reset),
        .start(start),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            start = 0;
            disconnect = 0;
            connecting_done = 0;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Successfull connection flow...");
            reset_dut();


            start = 1;
            @(posedge clk);
            start = 0;


            repeat(2) @(posedge clk);


            connecting_done = 1;
            @(posedge clk);
            connecting_done = 0;
            @(posedge clk);

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Disconnect during CONNECTING...");
            reset_dut();


            start = 1;
            @(posedge clk);
            start = 0;


            disconnect = 1;
            @(posedge clk);
            disconnect = 0;
            @(posedge clk);

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Disconnect after CONNECTED...");
            reset_dut();


            start = 1;
            @(posedge clk);
            start = 0;
            connecting_done = 1;
            @(posedge clk);
            connecting_done = 0;


            disconnect = 1;
            @(posedge clk);
            disconnect = 0;
            @(posedge clk);

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Ignore connecting_done in IDLE...");
            reset_dut();


            connecting_done = 1;
            @(posedge clk);
            connecting_done = 0;
            @(posedge clk);

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Verification of CONNECTING state persistence...");
            reset_dut();

            start = 1;
            @(posedge clk);
            start = 0;


            repeat(5) @(posedge clk);

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Reset priority check...");
            reset_dut();


            start = 1;
            @(posedge clk);
            start = 0;
            connecting_done = 1;
            @(posedge clk);
            connecting_done = 0;


            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);

            #1;


            check_outputs(2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bluetooth_state_machine Testbench");
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
        input [1:0] expected_state;
        begin
            if (expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: state=%h",
                         state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state=%h",
                         expected_state);
                $display("  Got:      state=%h",
                         state);
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
        $dumpvars(0,clk, connecting_done, disconnect, reset, start, state);
    end

endmodule
