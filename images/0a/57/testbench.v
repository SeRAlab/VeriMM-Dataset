`timescale 1ns/1ps

module sd_card_fsm_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg rw;
    reg start;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_fsm dut (
        .clk(clk),
        .reset(reset),
        .rw(rw),
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
            rw = 0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %03d: Reset to IDLE check", test_num);
            reset_dut();

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %03d: IDLE to READ (start=1, rw=0)", test_num);
            reset_dut();
            @(negedge clk);
            start = 1;
            rw = 0;
            @(negedge clk);

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %03d: IDLE to WRITE (start=1, rw=1)", test_num);
            reset_dut();
            @(negedge clk);
            start = 1;
            rw = 1;
            @(negedge clk);

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %03d: Stay in IDLE if start=0", test_num);
            reset_dut();
            @(negedge clk);
            start = 0;
            rw = 1;
            @(negedge clk);

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %03d: READ back to IDLE", test_num);
            reset_dut();

            @(negedge clk);
            start = 1;
            rw = 0;
            @(negedge clk);

            start = 0;
            @(negedge clk);

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %03d: WRITE back to IDLE", test_num);
            reset_dut();

            @(negedge clk);
            start = 1;
            rw = 1;
            @(negedge clk);

            start = 0;
            @(negedge clk);

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
        $display("sd_card_fsm Testbench");
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
        $dumpvars(0,clk, reset, rw, start, state);
    end

endmodule
