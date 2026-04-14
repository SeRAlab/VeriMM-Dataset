`timescale 1ns/1ps

module convolutional_encoder_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    reg reset;
    wire dout1;
    wire dout2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    convolutional_encoder dut (
        .clk(clk),
        .din(din),
        .reset(reset),
        .dout1(dout1),
        .dout2(dout2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            din = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task drive_bit;

        input bit_in;
        begin
            din = bit_in;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            $display("Running testcase001: Single '1' input");
            reset_dut();
            drive_bit(1);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Input sequence '11'");
            reset_dut();
            drive_bit(1);
            drive_bit(1);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Input sequence '010'");
            reset_dut();
            drive_bit(0);
            drive_bit(1);
            drive_bit(0);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Input sequence '000'");
            reset_dut();
            drive_bit(0);
            drive_bit(0);
            drive_bit(0);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Input sequence '111'");
            reset_dut();
            drive_bit(1);
            drive_bit(1);
            drive_bit(1);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Input sequence '101'");
            reset_dut();
            drive_bit(1);
            drive_bit(0);
            drive_bit(1);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("convolutional_encoder Testbench");
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
        input expected_dout1;
        input expected_dout2;
        begin
            if (expected_dout1 === (expected_dout1 ^ dout1 ^ expected_dout1) &&
                expected_dout2 === (expected_dout2 ^ dout2 ^ expected_dout2)) begin
                $display("PASS");
                $display("  Outputs: dout1=%b, dout2=%b",
                         dout1, dout2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout1=%b, dout2=%b",
                         expected_dout1, expected_dout2);
                $display("  Got:      dout1=%b, dout2=%b",
                         dout1, dout2);
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
        $dumpvars(0,clk, din, reset, dout1, dout2);
    end

endmodule
