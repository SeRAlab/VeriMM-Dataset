`timescale 1ns/1ps

module chacha20_quarter_round_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] key;
    reg [31:0] nonce;
    reg reset;
    wire [127:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha20_quarter_round dut (
        .clk(clk),
        .key(key),
        .nonce(nonce),
        .reset(reset),
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
            key = 0;
            nonce = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (Key=0, Nonce=0)", test_num);
            reset_dut();
            key = 32'h00000000;
            nonce = 32'h00000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'hB7877FEE4983DCE65A84003FE21E9ECF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard Mixed Inputs", test_num);
            reset_dut();
            key = 32'h12345678;
            nonce = 32'h87654321;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'hE1B0A3240C7159D5C41336F46DD0802F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Values (All F)", test_num);
            reset_dut();
            key = 32'hFFFFFFFF;
            nonce = 32'hFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h1B5980DDD7835587B6460ED23DE1AD63);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            reset_dut();
            key = 32'hAAAAAAAA;
            nonce = 32'h55555555;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h9F8703413D201A943D0C5478189D6AF1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit Key", test_num);
            reset_dut();
            key = 32'h00000001;
            nonce = 32'h00000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'hC7878FEE21F43C8E7A54FFFF01EE9EBF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha20_quarter_round Testbench");
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
        input [127:0] expected_state;
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
        $dumpvars(0,clk, key, nonce, reset, state);
    end

endmodule
