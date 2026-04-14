`timescale 1ns/1ps

module sata_controller_tb;

    // Testbench signals (sequential circuit)
    reg activate;
    reg clk;
    reg error;
    reg reset;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_controller dut (
        .activate(activate),
        .clk(clk),
        .error(error),
        .reset(reset),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            activate = 0;
            error = 0;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Transition IDLE -> ACTIVE");
            test_num = 1;
            reset_dut();

            activate = 1;
            @(posedge clk);
            #1;
            activate = 0;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Transition IDLE -> ACTIVE -> ERROR");
            test_num = 2;
            reset_dut();


            activate = 1;
            @(posedge clk);
            #1;
            activate = 0;


            error = 1;
            @(posedge clk);
            #1;
            error = 0;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Transition ERROR -> IDLE via Reset");
            test_num = 3;
            reset_dut();


            activate = 1;
            @(posedge clk);
            #1;
            activate = 0;
            error = 1;
            @(posedge clk);
            #1;
            error = 0;


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Transition ACTIVE -> IDLE via Reset");
            test_num = 4;
            reset_dut();


            activate = 1;
            @(posedge clk);
            #1;
            activate = 0;


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Stay in IDLE (no activate)");
            test_num = 5;
            reset_dut();

            activate = 0;
            error = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: ERROR persistence (Ignoring activate)");
            test_num = 6;
            reset_dut();


            activate = 1;
            @(posedge clk);
            #1;
            activate = 0;
            error = 1;
            @(posedge clk);
            #1;
            error = 0;


            activate = 1;
            @(posedge clk);
            #1;
            activate = 0;

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
        $display("sata_controller Testbench");
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
        $dumpvars(0,activate, clk, error, reset, state);
    end

endmodule
