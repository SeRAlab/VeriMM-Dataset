`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [31:0] MAX_VAL;
    reg RST;
    wire [31:0] COUNT;
    wire DONE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .MAX_VAL(MAX_VAL),
        .RST(RST),
        .COUNT(COUNT),
        .DONE(DONE)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            MAX_VAL = 0;
            @(posedge CLK);
            #1;
            RST = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(32'd0, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Count to 5", test_num);
            reset_dut();
            MAX_VAL = 32'd5;

            repeat(5) @(posedge CLK);
            #2;
            #1;

            check_outputs(32'd5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Count to 100", test_num);
            reset_dut();
            MAX_VAL = 32'd100;
            repeat(100) @(posedge CLK);
            #2;
            #1;

            check_outputs(32'd100, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: Reset mid-count", test_num);
            reset_dut();
            MAX_VAL = 32'd20;
            repeat(10) @(posedge CLK);


            RST = 1;
            @(posedge CLK);
            #1;
            RST = 0;
            @(posedge CLK);
            #1;




            #1;





            check_outputs(32'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Test Case %0d: MAX_VAL = 1", test_num);
            reset_dut();
            MAX_VAL = 32'd1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(32'd1, 1'b1);
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
        input [31:0] expected_COUNT;
        input expected_DONE;
        begin
            if (expected_COUNT === (expected_COUNT ^ COUNT ^ expected_COUNT) &&
                expected_DONE === (expected_DONE ^ DONE ^ expected_DONE)) begin
                $display("PASS");
                $display("  Outputs: COUNT=%h, DONE=%b",
                         COUNT, DONE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUNT=%h, DONE=%b",
                         expected_COUNT, expected_DONE);
                $display("  Got:      COUNT=%h, DONE=%b",
                         COUNT, DONE);
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
        $dumpvars(0,CLK, MAX_VAL, RST, COUNT, DONE);
    end

endmodule
