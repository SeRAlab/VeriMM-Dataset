`timescale 1ns/1ps

module ADC_Controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] analog_in;
    reg clk;
    reg enable;
    wire [23:0] digital_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ADC_Controller dut (
        .analog_in(analog_in),
        .clk(clk),
        .enable(enable),
        .digital_out(digital_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            analog_in = 8'h0;
            enable = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum Value (0x00) - Enable High", test_num);
            reset_dut();
            analog_in = 8'h00;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Value (0xFF) - Enable High", test_num);
            reset_dut();
            analog_in = 8'hFF;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'h0000FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range Value (0xA5) - Enable High", test_num);
            reset_dut();
            analog_in = 8'hA5;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'h0000A5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Disabled check - Output should not update", test_num);
            reset_dut();

            analog_in = 8'h11;
            enable = 1;
            @(posedge clk);
            #1;

            enable = 0;
            analog_in = 8'hEE;
            @(posedge clk);
            #2;

            #1;


            check_outputs(24'h000011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Re-enabling conversion", test_num);
            reset_dut();

            analog_in = 8'h55;
            enable = 0;
            @(posedge clk);
            #1;

            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'h000055);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple consecutive updates", test_num);
            reset_dut();
            enable = 1;
            analog_in = 8'h10;
            @(posedge clk);
            #1;
            analog_in = 8'h20;
            @(posedge clk);
            #1;
            analog_in = 8'h30;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'h000030);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ADC_Controller Testbench");
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
        input [23:0] expected_digital_out;
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
        $dumpvars(0,analog_in, clk, enable, digital_out);
    end

endmodule
