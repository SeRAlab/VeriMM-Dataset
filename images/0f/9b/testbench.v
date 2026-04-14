`timescale 1ns/1ps

module wifi_state_machine_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg connect;
    reg reset;
    reg start;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_state_machine dut (
        .clk(clk),
        .connect(connect),
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
            reset = 1;
            start = 0;
            connect = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Testing reset state...", test_num);
            reset_dut();
            #1;

            check_outputs(IDLE);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Testing IDLE to SCANNING (start=1)...", test_num);
            reset_dut();
            start = 1;
            @(posedge clk);
            #1 start = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(SCANNING);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Testing SCANNING to CONNECTING (connect=1)...", test_num);
            reset_dut();

            start = 1; @(posedge clk); #1 start = 0;
            @(posedge clk);

            connect = 1;
            @(posedge clk);
            #1 connect = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(CONNECTING);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Testing full path to CONNECTED...", test_num);
            reset_dut();

            start = 1; @(posedge clk); #1 start = 0; @(posedge clk);

            connect = 1; @(posedge clk); #1 connect = 0; @(posedge clk);

            @(posedge clk);
            #1 #1;
 check_outputs(CONNECTED);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Testing Reset from CONNECTED state...", test_num);
            reset_dut();

            start = 1; @(posedge clk); #1 start = 0; @(posedge clk);
            connect = 1; @(posedge clk); #1 connect = 0; @(posedge clk);
            @(posedge clk);


            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(IDLE);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Testing 'connect' input ignored in IDLE...", test_num);
            reset_dut();
            connect = 1;
            @(posedge clk);
            #1 connect = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(IDLE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_state_machine Testbench");
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
        $dumpvars(0,clk, connect, reset, start, state);
    end

endmodule
