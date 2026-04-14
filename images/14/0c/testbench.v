`timescale 1ns/1ps

module ADC_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] control;
    reg reset;
    reg sample;
    wire [7:0] output_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ADC dut (
        .clk(clk),
        .control(control),
        .reset(reset),
        .sample(sample),
        .output_value(output_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control = 0;
            sample = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Set LSB (bit 0) to 1");
            reset_dut();
            control = 3'd0;
            sample = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Set MSB (bit 7) to 1");
            reset_dut();
            control = 3'd7;
            sample = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Running testcase003: Set all bits to 1");
            reset_dut();
            for (i = 0; i < 8; i = i + 1) begin
                control = i;
                sample = 1'b1;
                @(posedge clk);
                #1;
            end
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Set pattern 10101010 (0xAA)");
            reset_dut();

            control = 3'd1; sample = 1; @(posedge clk); #1;
            control = 3'd3; sample = 1; @(posedge clk); #1;
            control = 3'd5; sample = 1; @(posedge clk); #1;
            control = 3'd7; sample = 1; @(posedge clk); #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Set pattern 01010101 (0x55)");
            reset_dut();

            control = 3'd0; sample = 1; @(posedge clk); #1;
            control = 3'd2; sample = 1; @(posedge clk); #1;
            control = 3'd4; sample = 1; @(posedge clk); #1;
            control = 3'd6; sample = 1; @(posedge clk); #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Set bit 4 to 1 then overwrite to 0");
            reset_dut();
            control = 3'd4; sample = 1; @(posedge clk); #1;
            control = 3'd4; sample = 0; @(posedge clk); #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Set bits 2 and 3 sequentially");
            reset_dut();
            control = 3'd2; sample = 1; @(posedge clk); #1;
            control = 3'd3; sample = 1; @(posedge clk); #1;
            #1;

            check_outputs(8'h0C);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Reset during operation");
            reset_dut();
            control = 3'd7; sample = 1; @(posedge clk); #1;
            reset = 1; @(posedge clk); #1;
            reset = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ADC Testbench");
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
        input [7:0] expected_output_value;
        begin
            if (expected_output_value === (expected_output_value ^ output_value ^ expected_output_value)) begin
                $display("PASS");
                $display("  Outputs: output_value=%h",
                         output_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_value=%h",
                         expected_output_value);
                $display("  Got:      output_value=%h",
                         output_value);
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
        $dumpvars(0,clk, control, reset, sample, output_value);
    end

endmodule
