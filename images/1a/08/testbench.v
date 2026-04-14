`timescale 1ns/1ps

module ADC_8bit_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] analog_in;
    reg clk;
    reg reset;
    wire [7:0] digital_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ADC_8bit dut (
        .analog_in(analog_in),
        .clk(clk),
        .reset(reset),
        .digital_out(digital_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            analog_in = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset Check");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Analog Input 0");
            reset_dut();
            analog_in = 3'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Analog Input 1 (Linear Step)");
            reset_dut();
            analog_in = 3'd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Analog Input 2 (Linear Step)");
            reset_dut();
            analog_in = 3'd2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h24);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Analog Input 3 (Linear Step)");
            reset_dut();
            analog_in = 3'd3;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h36);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Analog Input 4 (Linear Step)");
            reset_dut();
            analog_in = 3'd4;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h48);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Analog Input 5 (Linear Step)");
            reset_dut();
            analog_in = 3'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase 008: Analog Input 6 (Linear Step)");
            reset_dut();
            analog_in = 3'd6;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h6C);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase 009: Analog Input 7 (Full Scale)");
            reset_dut();
            analog_in = 3'd7;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h7F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ADC_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [7:0] expected_digital_out;
        begin
            if (expected_digital_out === (expected_digital_out ^ digital_out ^ expected_digital_out)) begin
                $display("PASS");
                $display("  Outputs: digital_out=%h",
                         digital_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digital_out=%h",
                         expected_digital_out);
                $display("  Got:      digital_out=%h",
                         digital_out);
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
        $dumpvars(0,analog_in, clk, reset, digital_out);
    end

endmodule
