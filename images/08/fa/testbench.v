`timescale 1ns/1ps

module aes_encryption_tb;

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
    aes_encryption dut (
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
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: All Zeros Input and Key", test_num);
            state_in = 128'h00000000000000000000000000000000;
            round_key = 128'h00000000000000000000000000000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h63636363636363636363636363636363);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: FIPS-197 Standard Round 1 Vector", test_num);
            state_in = 128'h193de3bea0f4e22b9ac68d2ae9f84808;
            round_key = 128'ha0fafe1788542cb123a339392a6c7605;
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'ha4686b20c89f352b6b5bef43026a5049);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: All Ones Input with Zero Key", test_num);
            state_in = 128'hffffffffffffffffffffffffffffffff;
            round_key = 128'h00000000000000000000000000000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h16161616161616161616161616161616);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Zero Input with All Ones Key", test_num);
            state_in = 128'h00000000000000000000000000000000;
            round_key = 128'hffffffffffffffffffffffffffffffff;
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: FIPS-197 Standard Round 2 Vector", test_num);
            state_in = 128'ha4686b20c89f352b6b5bef43026a5049;
            round_key = 128'h428353118212b159539111888a733c8a;
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h1ac3707598a88f8c89bc0849343228a8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_encryption Testbench");
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
