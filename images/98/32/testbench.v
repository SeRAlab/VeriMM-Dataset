`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [15:0] load_data;
    reg reset;
    reg shift_enable;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .load(load),
        .load_data(load_data),
        .reset(reset),
        .shift_enable(shift_enable),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            load_data = 16'b0;
            shift_enable = 0;
            #15;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Async Reset Check");
            reset_dut();
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Parallel Load 0xAAAA");
            reset_dut();
            load = 1;
            load_data = 16'hAAAA;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Single Left Shift (0x0001 -> 0x0002)");
            reset_dut();

            load = 1;
            load_data = 16'h0001;
            @(posedge clk);
            #1;
            load = 0;

            shift_enable = 1;
            @(posedge clk);
            #1;
            shift_enable = 0;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Multiple Left Shifts (0x000F shift 4 times -> 0x00F0)");
            reset_dut();
            load = 1;
            load_data = 16'h000F;
            @(posedge clk);
            #1;
            load = 0;
            shift_enable = 1;
            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            shift_enable = 0;
            #1;

            check_outputs(16'h00F0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Load Priority Check (Load and Shift both high)");
            reset_dut();

            load = 1;
            load_data = 16'h1234;
            @(posedge clk);
            #1;

            load = 1;
            load_data = 16'h5678;
            shift_enable = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift_enable = 0;
            #1;

            check_outputs(16'h5678);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Shift Enable Low (Hold State)");
            reset_dut();
            load = 1;
            load_data = 16'hFF00;
            @(posedge clk);
            #1;
            load = 0;
            shift_enable = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Shift MSB out (0x8000 -> 0x0000)");
            reset_dut();
            load = 1;
            load_data = 16'h8000;
            @(posedge clk);
            #1;
            load = 0;
            shift_enable = 1;
            @(posedge clk);
            #1;
            shift_enable = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Shift 0xFFFF left once");
            reset_dut();
            load = 1;
            load_data = 16'hFFFF;
            @(posedge clk);
            #1;
            load = 0;
            shift_enable = 1;
            @(posedge clk);
            #1;
            shift_enable = 0;
            #1;

            check_outputs(16'hFFFE);
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
        input [15:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, load, load_data, reset, shift_enable, q);
    end

endmodule
