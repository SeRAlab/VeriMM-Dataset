`timescale 1ns/1ps

module shift_register_8bit_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] D;
    reg clk;
    reg load;
    reg reset;
    reg shift;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_8bit dut (
        .D(D),
        .clk(clk),
        .load(load),
        .reset(reset),
        .shift(shift),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            load = 0;
            shift = 0;
            D = 8'h00;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Synchronous Reset");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Parallel Load 0xA5");
            reset_dut();
            @(negedge clk);
            load = 1;
            D = 8'hA5;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Shift Left (0x01 -> 0x02)");
            reset_dut();

            @(negedge clk);
            load = 1; D = 8'h01;
            @(negedge clk);
            load = 0;

            shift = 1;
            @(negedge clk);
            shift = 0;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Shift Left 7 times (0x01 -> 0x80)");
            reset_dut();

            @(negedge clk);
            load = 1; D = 8'h01;
            @(negedge clk);
            load = 0;

            shift = 1;
            for(i=0; i<7; i=i+1) @(negedge clk);
            shift = 0;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Shift Out (0x80 -> 0x00)");
            reset_dut();

            @(negedge clk);
            load = 1; D = 8'h80;
            @(negedge clk);
            load = 0;

            shift = 1;
            @(negedge clk);
            shift = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Load Priority (Both load and shift active)");
            reset_dut();
            @(negedge clk);
            load = 1;
            shift = 1;
            D = 8'hFF;
            @(negedge clk);
            load = 0;
            shift = 0;


            #1;



            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Hold Value");
            reset_dut();
            @(negedge clk);
            load = 1; D = 8'h55;
            @(negedge clk);
            load = 0; shift = 0;
            @(negedge clk);
            #1;

            check_outputs(8'h55);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_8bit Testbench");
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
        input [7:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, clk, load, reset, shift, Q);
    end

endmodule
