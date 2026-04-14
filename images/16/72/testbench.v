`timescale 1ns/1ps

module chacha20_key_schedule_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [255:0] key;
    reg [63:0] nonce;
    reg rst;
    wire [255:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_key_schedule dut (
        .clk(clk),
        .key(key),
        .nonce(nonce),
        .rst(rst),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            key = 0;
            nonce = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            reset_dut();
            key = 256'h0;
            nonce = 64'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs({128'h0, CONSTANTS});
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            reset_dut();
            key = {256{1'b1}};
            nonce = {64{1'b1}};
            @(posedge clk);
            #1;
            #1;

            check_outputs({128'hffffffff_ffffffff_ffffffff_ffffffff, CONSTANTS});
        end
        endtask

    task testcase003;

        reg [255:0] test_key;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Incremental Key", test_num);
            reset_dut();

            test_key = 256'h1f1e1d1c_1b1a1918_17161514_13121110_0f0e0d0c_0b0a0908_07060504_03020100;
            key = test_key;
            nonce = 64'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs({32'h0f0e0d0c, 32'h0b0a0908, 32'h07060504, 32'h03020100, CONSTANTS});
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_key_schedule Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        
        
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
        input [255:0] expected_state;
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
        $dumpvars(0,clk, key, nonce, rst, state);
    end

endmodule
