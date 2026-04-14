`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg load;
    reg reset;
    reg shift;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .shift(shift),
        .data_out(data_out)
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
            shift = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Load...");
            reset_dut();
            data_in = 32'hDEADBEEF;
            load = 1;
            shift = 0;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Right Shift...");
            reset_dut();

            data_in = 32'h00000002;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift = 1;
            @(posedge clk);
            #1 shift = 0;

            #1;


            check_outputs(32'h00000001);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running testcase003: Multiple Right Shifts...");
            reset_dut();
            data_in = 32'hF0000000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift = 1;
            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
            end
            #1 shift = 0;

            #1;


            check_outputs(32'h0F000000);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running testcase004: Shift Out All Bits...");
            reset_dut();
            data_in = 32'hFFFFFFFF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            shift = 1;
            for (i = 0; i < 32; i = i + 1) begin
                @(posedge clk);
            end
            #1 shift = 0;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Load Priority Test...");
            reset_dut();
            data_in = 32'hAAAA_AAAA;
            load = 1;
            shift = 1;
            @(posedge clk);
            #1 load = 0; shift = 0;

            #1;


            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: No Operation Hold Test...");
            reset_dut();
            data_in = 32'h12345678;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(32'h12345678);
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
        input [31:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, load, reset, shift, data_out);
    end

endmodule
