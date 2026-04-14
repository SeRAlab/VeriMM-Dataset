`timescale 1ns/1ps

module ofdm_modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] symbol_in;
    wire [3:0] symbol_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_modulator dut (
        .clk(clk),
        .reset(reset),
        .symbol_in(symbol_in),
        .symbol_out(symbol_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            symbol_in = 0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Input 0 (0 * 3 = 0)", test_num);
            symbol_in = 4'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Input 2 (2 * 3 = 6)", test_num);
            symbol_in = 4'd2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Input 5 (5 * 3 = 15, Max boundary)", test_num);
            symbol_in = 4'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Input 6 (6 * 3 = 18 -> Saturation 15)", test_num);
            symbol_in = 4'd6;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Input 15 (15 * 3 = 45 -> Saturation 15)", test_num);
            symbol_in = 4'd15;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Input 4 (4 * 3 = 12)", test_num);
            symbol_in = 4'd4;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd12);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Reset verification", test_num);


            symbol_in = 4'd10;
            @(posedge clk);
            #2;


            reset = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ofdm_modulator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_symbol_out;
        begin
            if (expected_symbol_out === (expected_symbol_out ^ symbol_out ^ expected_symbol_out)) begin
                $display("PASS");
                $display("  Outputs: symbol_out=%h",
                         symbol_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: symbol_out=%h",
                         expected_symbol_out);
                $display("  Got:      symbol_out=%h",
                         symbol_out);
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
        $dumpvars(0,clk, reset, symbol_in, symbol_out);
    end

endmodule
