`timescale 1ns/1ps

module aes_round_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [127:0] round_key;
    reg [127:0] state;
    wire [127:0] next_state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_round dut (
        .clk(clk),
        .reset(reset),
        .round_key(round_key),
        .state(state),
        .next_state(next_state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            state = 0;
            round_key = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %03d: FIPS 197 Round 1 Vector", test_num);

            state = 128'h193de3bea0f4e22b9ac68d2ae9f84808;

            round_key = 128'ha0fafe1788542cb123a339392a6c7605;

            @(posedge clk);
            #2;
            #1;

            check_outputs(128'ha49c7bf2689faf2b6b5be548fcccbfe0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %03d: All Zeros State and Key", test_num);
            state = 128'h00000000000000000000000000000000;
            round_key = 128'h00000000000000000000000000000000;

            @(posedge clk);
            #2;

            #1;


            check_outputs(128'h63636363636363636363636363636363);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %03d: FIPS 197 Round 2 Vector", test_num);

            state = 128'ha49c7bf2689faf2b6b5be548fcccbfe0;

            round_key = 128'h42675a06ebd304c6854f7212457b19b6;

            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h5e0e3451a74c06351b9feb32a2340037);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %03d: High Bit Influence (All FFs)", test_num);
            state = 128'hffffffffffffffffffffffffffffffff;
            round_key = 128'h00000000000000000000000000000000;

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
        input [127:0] expected_next_state;
        begin
            if (expected_next_state === (expected_next_state ^ next_state ^ expected_next_state)) begin
                $display("PASS");
                $display("  Outputs: next_state=%h",
                         next_state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_state=%h",
                         expected_next_state);
                $display("  Got:      next_state=%h",
                         next_state);
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
        $dumpvars(0,clk, reset, round_key, state, next_state);
    end

endmodule
