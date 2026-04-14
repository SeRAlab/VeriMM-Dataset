`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] ADDR;
    reg CLK;
    reg [9:0] DATA_IN;
    reg WE;
    wire [9:0] DATA_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ADDR(ADDR),
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .WE(WE),
        .DATA_OUT(DATA_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            WE = 0;
            ADDR = 0;
            DATA_IN = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Simple Write/Read at Addr 0");
            reset_dut();
            test_num = 1;


            ADDR = 8'h00;
            DATA_IN = 10'h2AA;
            WE = 1;
            @(posedge CLK);
            #1;


            WE = 0;
            #1;
            #1;

            check_outputs(10'h2AA);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Write/Read at Addr 255");
            reset_dut();
            test_num = 2;


            ADDR = 8'hFF;
            DATA_IN = 10'h3FF;
            WE = 1;
            @(posedge CLK);
            #1;


            WE = 0;
            #1;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Verify WE=0 prevents writing");
            reset_dut();
            test_num = 3;


            ADDR = 8'h10;
            DATA_IN = 10'h123;
            WE = 1;
            @(posedge CLK);
            #1;


            DATA_IN = 10'h3FF;
            WE = 0;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(10'h123);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Overwriting data");
            reset_dut();
            test_num = 4;


            ADDR = 8'h55;
            DATA_IN = 10'h0F0;
            WE = 1;
            @(posedge CLK);
            #1;


            DATA_IN = 10'h30C;
            @(posedge CLK);
            #1;

            WE = 0;
            #1;
            #1;

            check_outputs(10'h30C);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Data persistence across multiple addresses");
            reset_dut();
            test_num = 5;


            ADDR = 8'h0A;
            DATA_IN = 10'h111;
            WE = 1;
            @(posedge CLK);
            #1;


            ADDR = 8'h0B;
            DATA_IN = 10'h222;
            WE = 1;
            @(posedge CLK);
            #1;


            WE = 0;
            ADDR = 8'h0A;
            #1;
            #1;

            check_outputs(10'h111);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Continuous read reflection");
            reset_dut();
            test_num = 6;


            ADDR = 8'hCC;
            DATA_IN = 10'h055;
            WE = 1;
            @(posedge CLK);
            #1;


            WE = 0;
            DATA_IN = 10'h3FF;
            #5;


            #1;



            check_outputs(10'h055);
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
        input [9:0] expected_DATA_OUT;
        begin
            if (expected_DATA_OUT === (expected_DATA_OUT ^ DATA_OUT ^ expected_DATA_OUT)) begin
                $display("PASS");
                $display("  Outputs: DATA_OUT=%h",
                         DATA_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA_OUT=%h",
                         expected_DATA_OUT);
                $display("  Got:      DATA_OUT=%h",
                         DATA_OUT);
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
        $dumpvars(0,ADDR, CLK, DATA_IN, WE, DATA_OUT);
    end

endmodule
