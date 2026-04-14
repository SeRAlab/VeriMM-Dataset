`timescale 1ns/1ps

module sata_controller_tb;

    // Testbench signals (sequential circuit)
    reg busy;
    reg clk;
    reg reset;
    reg start;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sata_controller dut (
        .busy(busy),
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
            $display("\nResetting DUT...");
            reset = 1;
            start = 0;
            busy = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Power-on Reset to IDLE", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: IDLE to TRANSFER transition", test_num);
            reset_dut();

            start = 1;
            @(posedge clk);
            #1;
            start = 0;


            #1;



            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Maintain TRANSFER state while busy", test_num);
            reset_dut();


            start = 1;
            @(posedge clk);
            #1;
            start = 0;
            busy = 1;


            repeat(3) @(posedge clk);
            #1;


            #1;



            check_outputs(2'b01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: TRANSFER to DONE transition", test_num);
            reset_dut();


            start = 1;
            @(posedge clk);
            #1;
            start = 0;
            busy = 1;
            @(posedge clk);
            #1;


            busy = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Return to IDLE from DONE via Reset", test_num);
            reset_dut();


            start = 1;
            @(posedge clk);
            #1;
            start = 0;
            busy = 0;
            @(posedge clk);
            #1;


            if (state !== 2'b10) $display("Warning: Setup to DONE state failed");


            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Shortest path IDLE to DONE", test_num);
            reset_dut();


            start = 1;
            busy = 0;
            @(posedge clk);
            #1;
            start = 0;
            @(posedge clk);
            #1;


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
        $dumpvars(0,busy, clk, reset, start, state);
    end

endmodule
