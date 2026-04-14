`timescale 1ns/1ps

module aes_round_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] key;
    reg [127:0] state;
    wire [127:0] new_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_round dut (
        .clk(clk),
        .key(key),
        .state(state),
        .new_state(new_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            state <= 128'h0;
            key <= 128'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: NIST AES Round 1", test_num);
            reset_dut();
            state <= 128'h193de3bea0f4e22b9ac68d2ae9f84808;
            key   <= 128'ha0fafe1788542cb123a339392a6c7605;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'ha49c7ff2689f352b6b5be187026a5049);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Input", test_num);
            reset_dut();
            state <= 128'h00000000000000000000000000000000;
            key   <= 128'h00000000000000000000000000000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h63636363636363636363636363636363);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: NIST AES Round 2", test_num);
            reset_dut();
            state <= 128'ha49c7ff2689f352b6b5be187026a5049;
            key   <= 128'hf2c295f27a96b9435935807a7359f67f;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'haa8f5f03618de74a8225b2d4c38246da);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones State, Zero Key", test_num);
            reset_dut();
            state <= 128'hffffffffffffffffffffffffffffffff;
            key   <= 128'h00000000000000000000000000000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h16161616161616161616161616161616);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero State, All Ones Key", test_num);
            reset_dut();
            state <= 128'h00000000000000000000000000000000;
            key   <= 128'hffffffffffffffffffffffffffffffff;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c9c);
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
        input [127:0] expected_new_state;
        begin
            if (expected_new_state === (expected_new_state ^ new_state ^ expected_new_state)) begin
                $display("PASS");
                $display("  Outputs: new_state=%h",
                         new_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_state=%h",
                         expected_new_state);
                $display("  Got:      new_state=%h",
                         new_state);
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
        $dumpvars(0,clk, key, state, new_state);
    end

endmodule
