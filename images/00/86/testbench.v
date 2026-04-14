`timescale 1ns/1ps

module sd_card_interface_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg read_enable;
    reg reset;
    reg start;
    reg write_enable;
    wire [2:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sd_card_interface dut (
        .clk(clk),
        .read_enable(read_enable),
        .reset(reset),
        .start(start),
        .write_enable(write_enable),
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
            read_enable = 0;
            write_enable = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset to IDLE");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: IDLE to INIT");
            test_num = 2;
            reset_dut();
            @(posedge clk);
            start = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: IDLE to READ");
            test_num = 3;
            reset_dut();
            @(posedge clk);
            read_enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd2);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: IDLE to WRITE");
            test_num = 4;
            reset_dut();
            @(posedge clk);
            write_enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd3);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: IDLE to ERROR (Simultaneous Read/Write)");
            test_num = 5;
            reset_dut();
            @(posedge clk);
            read_enable = 1;
            write_enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd4);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Reset Recovery from ERROR");
            test_num = 6;
            reset_dut();
            @(posedge clk);
            read_enable = 1;
            write_enable = 1;
            @(posedge clk);
            #1;
            reset_dut();

            #1;


            check_outputs(3'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sd_card_interface Testbench");
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
        input [2:0] expected_state;
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
        $dumpvars(0,clk, read_enable, reset, start, write_enable, state);
    end

endmodule
