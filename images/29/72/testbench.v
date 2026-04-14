`timescale 1ns/1ps

module aes_round_transform_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [127:0] round_key;
    reg [127:0] state;
    wire [127:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_round_transform dut (
        .clk(clk),
        .reset(reset),
        .round_key(round_key),
        .state(state),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            state = 128'h0;
            round_key = 128'h0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            state = 128'h0;
            round_key = 128'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            state = 128'hCAFEBABE_DEADBEEF_01234567_89ABCDEF;
            round_key = 128'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'hCAFEBABE_DEADBEEF_01234567_89ABCDEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            state = 128'hFFFFFFFF_00000000_55555555_AAAAAAAA;
            round_key = 128'hFFFFFFFF_00000000_55555555_AAAAAAAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            state = 128'h00000000_00000000_00000000_00000000;
            round_key = 128'hFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'hFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            state = 128'h3243f6a8885a308d313198a2e0370734;
            round_key = 128'h2b7e151628aed2a6abf7158809cf4f3c;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h193de3bea0f4e22b9ac68d2ae9f84808);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            state = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            round_key = 128'h55555555555555555555555555555555;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'hFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_round_transform Testbench");
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
        input [127:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, reset, round_key, state, out);
    end

endmodule
