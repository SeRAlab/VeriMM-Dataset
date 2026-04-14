`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] DATA_IN;
    reg LOAD_EN;
    reg SHIFT_EN;
    wire [3:0] DATA_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .LOAD_EN(LOAD_EN),
        .SHIFT_EN(SHIFT_EN),
        .DATA_OUT(DATA_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            LOAD_EN = 1'b1;
            SHIFT_EN = 1'b0;
            DATA_IN = 4'b0000;
            @(posedge CLK);
            #1;
            LOAD_EN = 1'b0;
            DATA_IN = 4'b0000;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Loading 4'b1010", test_num);
            reset_dut();

            LOAD_EN = 1'b1;
            DATA_IN = 4'b1010;
            @(posedge CLK);
            #1;
            LOAD_EN = 1'b0;

            #1;


            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right Once (1000 -> 0100)", test_num);
            reset_dut();


            LOAD_EN = 1'b1;
            DATA_IN = 4'b1000;
            @(posedge CLK);
            #1;


            LOAD_EN = 1'b0;
            SHIFT_EN = 1'b1;
            @(posedge CLK);
            #1;
            SHIFT_EN = 1'b0;

            #1;


            check_outputs(4'b0100);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Circular Wrap-around (0001 -> 1000)", test_num);
            reset_dut();


            LOAD_EN = 1'b1;
            DATA_IN = 4'b0001;
            @(posedge CLK);
            #1;


            LOAD_EN = 1'b0;
            SHIFT_EN = 1'b1;
            @(posedge CLK);
            #1;
            SHIFT_EN = 1'b0;

            #1;


            check_outputs(4'b1000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Rotation (4 shifts of 1011)", test_num);
            reset_dut();


            LOAD_EN = 1'b1;
            DATA_IN = 4'b1011;
            @(posedge CLK);
            #1;


            LOAD_EN = 1'b0;
            SHIFT_EN = 1'b1;
            repeat(4) @(posedge CLK);
            #1;
            SHIFT_EN = 1'b0;

            #1;


            check_outputs(4'b1011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Check (LOAD_EN and SHIFT_EN both high)", test_num);
            reset_dut();




            LOAD_EN = 1'b1;
            SHIFT_EN = 1'b1;
            DATA_IN = 4'b1111;
            @(posedge CLK);
            #1;


            #1;



            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Hold (ENs low)", test_num);
            reset_dut();


            LOAD_EN = 1'b1;
            DATA_IN = 4'b0110;
            @(posedge CLK);
            #1;


            LOAD_EN = 1'b0;
            SHIFT_EN = 1'b0;
            repeat(2) @(posedge CLK);
            #1;

            #1;


            check_outputs(4'b0110);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros Shift", test_num);
            reset_dut();

            LOAD_EN = 1'b1;
            DATA_IN = 4'b0000;
            @(posedge CLK);
            #1;

            LOAD_EN = 1'b0;
            SHIFT_EN = 1'b1;
            repeat(3) @(posedge CLK);
            #1;

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones Shift", test_num);
            reset_dut();

            LOAD_EN = 1'b1;
            DATA_IN = 4'b1111;
            @(posedge CLK);
            #1;

            LOAD_EN = 1'b0;
            SHIFT_EN = 1'b1;
            repeat(5) @(posedge CLK);
            #1;

            #1;


            check_outputs(4'b1111);
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
        input [3:0] expected_DATA_OUT;
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
        $dumpvars(0,CLK, DATA_IN, LOAD_EN, SHIFT_EN, DATA_OUT);
    end

endmodule
