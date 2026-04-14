`timescale 1ns/1ps

module aes_round_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] round_key;
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
        .round_key(round_key),
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
            round_key = 0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: All Zeros Input, Zero Key");
            reset_dut();
            test_num = test_num + 1;
            state_in = 128'h00000000000000000000000000000000;
            round_key = 128'h00000000000000000000000000000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h63636363636363636363636363636363);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Incremental Bytes, Zero Key");
            reset_dut();
            test_num = test_num + 1;
            state_in = 128'h000102030405060708090a0b0c0d0e0f;
            round_key = 128'h00000000000000000000000000000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h637c777bf26b6f3001672bfed7ab76);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: All 0xFF Input, Zero Key");
            reset_dut();
            test_num = test_num + 1;
            state_in = 128'hffffffffffffffffffffffffffffffff;
            round_key = 128'h00000000000000000000000000000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h16161616161616161616161616161616);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: All Zeros Input, Key is SubBytes(0)");
            reset_dut();
            test_num = test_num + 1;
            state_in = 128'h00000000000000000000000000000000;
            round_key = 128'h63636363636363636363636363636363;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h00000000000000000000000000000000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Mixed Pattern Input and Key");
            reset_dut();
            test_num = test_num + 1;
            state_in = 128'h11223344112233441122334411223344;
            round_key = 128'hdeadbeefdeadbeefdeadbeefdeadbeef;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h5c3e7cf45c3e7cf45c3e7cf45c3e7cf4);
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
        $dumpvars(0,clk, round_key, rst, state_in, state_out);
    end

endmodule
