`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_sample;
    reg reset;
    wire [7:0] out_sample;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk(clk),
        .in_sample(in_sample),
        .reset(reset),
        .out_sample(out_sample)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in_sample = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Zero Value", test_num);
            reset_dut();
            in_sample = 8'h00;


            repeat(6) @(posedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Max Value", test_num);
            reset_dut();
            in_sample = 8'hFF;
            repeat(6) @(posedge clk);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Alternating Bits 0xAA", test_num);
            reset_dut();
            in_sample = 8'hAA;
            repeat(6) @(posedge clk);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Alternating Bits 0x55", test_num);
            reset_dut();
            in_sample = 8'h55;
            repeat(6) @(posedge clk);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Value Transition", test_num);
            reset_dut();


            in_sample = 8'h11;
            repeat(2) @(posedge clk);


            in_sample = 8'h22;
            repeat(2) @(posedge clk);


            repeat(2) @(posedge clk);

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Reset Behavior", test_num);
            reset_dut();
            in_sample = 8'hEE;
            repeat(4) @(posedge clk);


            reset = 1;
            repeat(2) @(posedge clk);

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
        $display("sample_rate_converter Testbench");
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
        input [7:0] expected_out_sample;
        begin
            if (expected_out_sample === (expected_out_sample ^ out_sample ^ expected_out_sample)) begin
                $display("PASS");
                $display("  Outputs: out_sample=%h",
                         out_sample);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_sample=%h",
                         expected_out_sample);
                $display("  Got:      out_sample=%h",
                         out_sample);
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
        $dumpvars(0,clk, in_sample, reset, out_sample);
    end

endmodule
