`timescale 1ns/1ps

module sd_card_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_controller dut (
        .clk(clk),
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
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic initialization flow");
            reset_dut();


            start = 1;
            @(posedge clk);
            start = 0;



            @(posedge clk);

            @(posedge clk);

            @(posedge clk);

            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Stay in IDLE without start signal");
            reset_dut();

            start = 0;
            repeat(5) @(posedge clk);

            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Reset during INIT state");
            reset_dut();

            start = 1;
            @(posedge clk);
            start = 0;


            @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Persistence in READY state");
            reset_dut();

            start = 1;
            @(posedge clk);
            start = 0;


            repeat(3) @(posedge clk);


            repeat(5) @(posedge clk);

            #1;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Short pulse start signal logic");
            reset_dut();


            start = 1;
            #2;
            start = 0;


            @(posedge clk);

            #1;



            #1;




            check_outputs(2'b01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sd_card_controller Testbench");
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
        $dumpvars(0,clk, reset, start, state);
    end

endmodule
