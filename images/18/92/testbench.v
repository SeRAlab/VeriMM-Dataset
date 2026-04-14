`timescale 1ns/1ps

module ofdm_modulator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] symbol;
    wire [15:0] o_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_modulator dut (
        .clk(clk),
        .symbol(symbol),
        .o_output(o_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            symbol = 4'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            reset_dut();
            symbol = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            reset_dut();
            symbol = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 1010", test_num);
            reset_dut();
            symbol = 4'hA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 0101", test_num);
            reset_dut();
            symbol = 4'h5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking One", test_num);
            reset_dut();
            symbol = 4'h1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Prime Pattern 0111", test_num);
            reset_dut();
            symbol = 4'h7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h7777);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 1100", test_num);
            reset_dut();
            symbol = 4'hC;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hCCCC);
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
        input [15:0] expected_o_output;
        begin
            if (expected_o_output === (expected_o_output ^ o_output ^ expected_o_output)) begin
                $display("PASS");
                $display("  Outputs: o_output=%h",
                         o_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_output=%h",
                         expected_o_output);
                $display("  Got:      o_output=%h",
                         o_output);
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
        $dumpvars(0,clk, symbol, o_output);
    end

endmodule
