`timescale 1ns/1ps

module aes_round_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] data_in;
    reg reset;
    reg [127:0] round_key;
    wire [127:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_round dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .round_key(round_key),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 0;
            round_key = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros Input and Round Key", test_num);
            reset_dut();
            data_in = 128'h00000000000000000000000000000000;
            round_key = 128'h00000000000000000000000000000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h63636363636363636363636363636363);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All 0xFF Input and Zero Round Key", test_num);
            reset_dut();
            data_in = 128'hffffffffffffffffffffffffffffffff;
            round_key = 128'h00000000000000000000000000000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h16161616161616161616161616161616);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Linear Input Vector with Zero Round Key", test_num);
            reset_dut();
            data_in = 128'h00102030405060708090a0b0c0d0e0f0;
            round_key = 128'h00000000000000000000000000000000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h5f72641557f5bc92f7be3b291db9f91a);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Round Key Cancellation Test", test_num);
            reset_dut();
            data_in = 128'h00000000000000000000000000000000;
            round_key = 128'h63636363636363636363636363636363;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h00000000000000000000000000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full Round (SubBytes/ShiftRows/MixColumns/AddRoundKey)", test_num);
            reset_dut();
            data_in = 128'h00102030405060708090a0b0c0d0e0f0;
            round_key = 128'hd6aa74fdd2af72fadaa678f1d6ab76fe;
            @(posedge clk);
            #2;
            #1;

            check_outputs(128'h89d810e8855ace682d1843d8cb128fe4);
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
        input [127:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, reset, round_key, data_out);
    end

endmodule
