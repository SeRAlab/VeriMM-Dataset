`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg direction;
    reg enable;
    reg load;
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
        .enable(enable),
        .load(load),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            load = 1;
            data_in = 8'h00;
            enable = 0;
            direction = 0;
            @(negedge clk);
            load = 0;
            data_in = 8'h00;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Parallel Load 0xA5");
            @(negedge clk);
            load = 1;
            data_in = 8'hA5;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Shift Left 0x01 four times");

            @(negedge clk);
            load = 1;
            data_in = 8'h01;
            @(negedge clk);
            load = 0;

            enable = 1;
            direction = 1;
            repeat(4) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Shift Right 0x80 four times");

            @(negedge clk);
            load = 1;
            data_in = 8'h80;
            @(negedge clk);
            load = 0;

            enable = 1;
            direction = 0;
            repeat(4) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Hold value when Enable=0");

            @(negedge clk);
            load = 1;
            data_in = 8'h55;
            @(negedge clk);
            load = 0;

            enable = 0;
            direction = 1;
            repeat(3) @(negedge clk);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Load priority over Shift");

            @(negedge clk);
            load = 1;
            data_in = 8'hAA;
            @(negedge clk);

            load = 1;
            enable = 1;
            direction = 1;
            data_in = 8'hEE;
            @(negedge clk);
            load = 0;
            enable = 0;
            #1;

            check_outputs(8'hEE);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Shift Left 8 times (clear register)");

            @(negedge clk);
            load = 1;
            data_in = 8'hFF;
            @(negedge clk);
            load = 0;

            enable = 1;
            direction = 1;
            repeat(8) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase 007: Shift Left then Right");

            @(negedge clk);
            load = 1;
            data_in = 8'h0F;
            @(negedge clk);
            load = 0;
            enable = 1;

            direction = 1;
            repeat(2) @(negedge clk);

            direction = 0;
            repeat(1) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(8'h1E);
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
        $dumpvars(0,clk, data_in, direction, enable, load, data_out);
    end

endmodule
