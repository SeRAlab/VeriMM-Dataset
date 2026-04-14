`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg direction;
    reg reset;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .direction(direction),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        input [7:0] load_val;
        begin
            reset = 1;
            data_in = load_val;
            direction = 0;
            @(posedge clk);
            #1;
            reset = 0;
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Rotate Left");
            reset_dut(8'hB1);
            direction = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h63);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Rotate Right");
            reset_dut(8'hB1);
            direction = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hD8);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Rotate Left 3 cycles");
            reset_dut(8'hA5);
            direction = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h2D);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Rotate Right 2 cycles");
            reset_dut(8'h3C);
            direction = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Full Rotate Left (8 cycles)");
            reset_dut(8'h12);
            direction = 0;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Mid-way direction change");
            reset_dut(8'h80);
            direction = 0;
            @(posedge clk);
            #1;
            direction = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Rotate All Zeros");
            reset_dut(8'h00);
            direction = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Rotate All Ones");
            reset_dut(8'hFF);
            direction = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, direction, reset, data_out);
    end

endmodule
