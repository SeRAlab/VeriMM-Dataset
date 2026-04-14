`timescale 1ns/1ps

module aes_round_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key_in;
    reg rst;
    reg [127:0] state_in;
    wire [127:0] state_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_round dut (
        .clk(clk),
        .key_in(key_in),
        .rst(rst),
        .state_in(state_in),
        .state_out(state_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            state_in = 0;
            key_in = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTest Case 001: All Zeros Input");
            reset_dut();
            test_num = test_num + 1;
            state_in = 128'h00000000000000000000000000000000;
            key_in = 128'h00000000000000000000000000000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h63636363636363636363636363636363);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: Standard Sequence Input");
            reset_dut();
            test_num = test_num + 1;
            state_in = 128'h00112233445566778899aabbccddeeff;
            key_in = 128'h00000000000000000000000000000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'hba84e8e775f1c1f1f0d0633ead44dd70);
        end
        endtask

    task testcase003;

        begin
            $display("\nTest Case 003: Constant Byte 0x01 Input");
            reset_dut();
            test_num = test_num + 1;
            state_in = 128'h01010101010101010101010101010101;
            key_in = 128'h00000000000000000000000000000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c7c);
        end
        endtask

    task testcase004;

        begin
            $display("\nTest Case 004: All 0xFF Input");
            reset_dut();
            test_num = test_num + 1;
            state_in = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
            key_in = 128'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h16161616161616161616161616161616);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_round Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [127:0] expected_state_out;
        begin
            if (expected_state_out === (expected_state_out ^ state_out ^ expected_state_out)) begin
                $display("PASS");
                $display("  Outputs: state_out=%h",
                         state_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: state_out=%h",
                         expected_state_out);
                $display("  Got:      state_out=%h",
                         state_out);
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
        $dumpvars(0,clk, key_in, rst, state_in, state_out);
    end

endmodule
