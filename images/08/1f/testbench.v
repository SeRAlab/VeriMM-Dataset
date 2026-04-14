`timescale 1ns/1ps

module adc_controller_tb;

    // Testbench signals (sequential circuit)
    reg [23:0] adc_data;
    reg clk;
    reg reset;
    reg valid;
    wire [23:0] data_out;
    wire data_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_controller dut (
        .adc_data(adc_data),
        .clk(clk),
        .reset(reset),
        .valid(valid),
        .data_out(data_out),
        .data_ready(data_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        valid = 0;
        adc_data = 24'b0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Basic Data Transfer", test_num);
        reset_dut();

        adc_data = 24'hABCDEF;
        valid = 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(24'hABCDEF, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Reset Verification", test_num);


        reset = 1;
        adc_data = 24'hFFFFFF;
        valid = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(24'h000000, 1'b0);
        reset = 0;
        @(posedge clk);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Data Stability", test_num);
        reset_dut();


        adc_data = 24'h123456;
        valid = 1;
        @(posedge clk);
        #1;


        adc_data = 24'h654321;
        valid = 0;
        @(posedge clk);
        #1;


        #1;



        check_outputs(24'h000000, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Max/Min Value Transfer", test_num);
        reset_dut();


        adc_data = 24'hFFFFFF;
        valid = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(24'hFFFFFF, 1'b1);


        adc_data = 24'h000000;
        valid = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(24'h000000, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Back-to-Back Transfers", test_num);
        reset_dut();


        adc_data = 24'hAAAAAA;
        valid = 1;
        @(posedge clk);
        #1;


        adc_data = 24'hBBBBBB;
        valid = 1;
        @(posedge clk);
        #1;


        #1;



        check_outputs(24'hBBBBBB, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_controller Testbench");
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
        input [23:0] expected_data_out;
        input expected_data_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_ready=%b",
                         data_out, data_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_ready=%b",
                         expected_data_out, expected_data_ready);
                $display("  Got:      data_out=%h, data_ready=%b",
                         data_out, data_ready);
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
        $dumpvars(0,adc_data, clk, reset, valid, data_out, data_ready);
    end

endmodule
