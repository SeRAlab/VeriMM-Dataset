`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg prbs_in;
    reg reset;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .prbs_in(prbs_in),
        .reset(reset),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            prbs_in = 0;
            lfsr_model = 23'h7FFFFF;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        reg feedback;
        begin
            test_num = test_num + 1;
            $display("Running Testcase%03d: Valid PRBS Sequence", test_num);
            reset_dut();

            for (i = 0; i < 100; i = i + 1) begin
                feedback = lfsr_model[22] ^ lfsr_model[17];
                prbs_in = feedback;
                lfsr_model = {lfsr_model[21:0], prbs_in};
                @(posedge clk);
            end
            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        integer i;
        reg feedback;
        begin
            test_num = test_num + 1;
            $display("Running Testcase%03d: Single Bit Error at End", test_num);
            reset_dut();

            for (i = 0; i < 49; i = i + 1) begin
                feedback = lfsr_model[22] ^ lfsr_model[17];
                prbs_in = feedback;
                lfsr_model = {lfsr_model[21:0], prbs_in};
                @(posedge clk);
            end


            feedback = lfsr_model[22] ^ lfsr_model[17];
            prbs_in = !feedback;
            @(posedge clk);

            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        integer i;
        reg feedback;
        begin
            test_num = test_num + 1;
            $display("Running Testcase%03d: Recovery after Error", test_num);
            reset_dut();


            feedback = lfsr_model[22] ^ lfsr_model[17];
            prbs_in = !feedback;
            lfsr_model = {lfsr_model[21:0], prbs_in};
            @(posedge clk);


            for (i = 0; i < 50; i = i + 1) begin
                feedback = lfsr_model[22] ^ lfsr_model[17];
                prbs_in = feedback;
                lfsr_model = {lfsr_model[21:0], prbs_in};
                @(posedge clk);
            end

            #2 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Running Testcase%03d: All-Zeros Input", test_num);
            reset_dut();

            for (i = 0; i < 30; i = i + 1) begin
                prbs_in = 1'b0;
                @(posedge clk);
            end

            #2 #1;
 check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_error;
        begin
            if (expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: error=%b",
                         error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b",
                         expected_error);
                $display("  Got:      error=%b",
                         error);
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
        $dumpvars(0,clk, prbs_in, reset, error);
    end

endmodule
