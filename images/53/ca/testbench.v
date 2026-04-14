`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [6:0] DATA_IN;
    reg EN;
    reg TE;
    wire [6:0] DATA_OUT;
    wire ENCLK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .EN(EN),
        .TE(TE),
        .DATA_OUT(DATA_OUT),
        .ENCLK(ENCLK)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            EN = 1;
            TE = 0;
            DATA_IN = 7'b0000000;
            repeat(7) @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Shift in all 1s", test_num);

            EN = 1;
            TE = 0;
            DATA_IN = 7'b1000000;
            repeat(7) @(posedge CLK);
            #1;

            #1;


            check_outputs(7'b1111111, 1'b1);
        end
        endtask

    task testcase002;

        integer i;
        reg [6:0] pattern;
        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Shift in pattern 1011001", test_num);

            pattern = 7'b1011001;
            EN = 1;
            TE = 0;

            for (i = 0; i < 7; i = i + 1) begin
                DATA_IN[6] = pattern[i];
                @(posedge CLK);
            end
            #1;




            #1;





            check_outputs(7'b1011001, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Hold (EN=0, TE=0)", test_num);


            EN = 1;
            DATA_IN = 7'b1000000;
            repeat(4) @(posedge CLK);


            EN = 0;
            TE = 0;
            DATA_IN = 7'b0000000;
            repeat(3) @(posedge CLK);
            #1;


            #1;



            check_outputs(7'b1111000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Test Enable (TE=1)", test_num);

            EN = 0;
            TE = 1;
            DATA_IN = 7'b1000000;
            repeat(2) @(posedge CLK);
            #1;


            #1;



            check_outputs(7'b1100000, 1'b0);
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
        input [6:0] expected_DATA_OUT;
        input expected_ENCLK;
        begin
            if (expected_DATA_OUT === (expected_DATA_OUT ^ DATA_OUT ^ expected_DATA_OUT) &&
                expected_ENCLK === (expected_ENCLK ^ ENCLK ^ expected_ENCLK)) begin
                $display("PASS");
                $display("  Outputs: DATA_OUT=%h, ENCLK=%b",
                         DATA_OUT, ENCLK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA_OUT=%h, ENCLK=%b",
                         expected_DATA_OUT, expected_ENCLK);
                $display("  Got:      DATA_OUT=%h, ENCLK=%b",
                         DATA_OUT, ENCLK);
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
        $dumpvars(0,CLK, DATA_IN, EN, TE, DATA_OUT, ENCLK);
    end

endmodule
