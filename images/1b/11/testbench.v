`timescale 1ns/1ps

module ofdm_modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] symbol;
    wire [3:0] modulated_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_modulator dut (
        .clk(clk),
        .symbol(symbol),
        .modulated_signal(modulated_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            symbol <= 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Symbol 4'b0000 (Min Value)", test_num);
            reset_dut();
            symbol <= 4'b0000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Symbol 4'b1111 (Max Value)", test_num);
            reset_dut();
            symbol <= 4'b1111;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Symbol 4'b1010 (Alternating Pattern A)", test_num);
            reset_dut();
            symbol <= 4'b1010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Symbol 4'b0101 (Alternating Pattern B)", test_num);
            reset_dut();
            symbol <= 4'b0101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Symbol 4'b1001 (Boundary Bits)", test_num);
            reset_dut();
            symbol <= 4'b1001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Symbol 4'b0001 (LSB Only)", test_num);
            reset_dut();
            symbol <= 4'b0001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Symbol 4'b1000 (MSB Only)", test_num);
            reset_dut();
            symbol <= 4'b1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b1000);
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
        input [3:0] expected_modulated_signal;
        begin
            if (expected_modulated_signal === (expected_modulated_signal ^ modulated_signal ^ expected_modulated_signal)) begin
                $display("PASS");
                $display("  Outputs: modulated_signal=%h",
                         modulated_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: modulated_signal=%h",
                         expected_modulated_signal);
                $display("  Got:      modulated_signal=%h",
                         modulated_signal);
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
        $dumpvars(0,clk, symbol, modulated_signal);
    end

endmodule
