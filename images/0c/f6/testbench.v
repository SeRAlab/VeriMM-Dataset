`timescale 1ns/1ps

module TemperatureSensor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [3:0] temp_in;
    wire temp_changed;
    wire [3:0] temp_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    TemperatureSensor dut (
        .clk(clk),
        .enable(enable),
        .temp_in(temp_in),
        .temp_changed(temp_changed),
        .temp_out(temp_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            temp_in = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Storage Update (Enable=1)");
            reset_dut();
            temp_in = 4'hA;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'hA);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Hold Value (Enable=0)");
            reset_dut();

            temp_in = 4'h5;
            enable = 1;
            @(posedge clk);
            #1;

            temp_in = 4'hE;
            enable = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'h5);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Successive Updates");
            reset_dut();

            temp_in = 4'h3;
            enable = 1;
            @(posedge clk);
            #1;

            temp_in = 4'hC;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'hC);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Edge Case Max Value (4'hF)");
            reset_dut();
            temp_in = 4'hF;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Input changes with Enable=0 (Should not update)");
            reset_dut();
            enable = 0;
            temp_in = 4'h9;
            @(posedge clk);
            #1;
            temp_in = 4'h2;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("TemperatureSensor Testbench");
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
        input expected_temp_changed;
        input [3:0] expected_temp_out;
        begin
            if (expected_temp_changed === (expected_temp_changed ^ temp_changed ^ expected_temp_changed) &&
                expected_temp_out === (expected_temp_out ^ temp_out ^ expected_temp_out)) begin
                $display("PASS");
                $display("  Outputs: temp_changed=%b, temp_out=%h",
                         temp_changed, temp_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: temp_changed=%b, temp_out=%h",
                         expected_temp_changed, expected_temp_out);
                $display("  Got:      temp_changed=%b, temp_out=%h",
                         temp_changed, temp_out);
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
        $dumpvars(0,clk, enable, temp_in, temp_changed, temp_out);
    end

endmodule
