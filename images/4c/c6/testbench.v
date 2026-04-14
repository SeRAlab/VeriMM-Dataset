`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] A1ADDR;
    reg A1DATA;
    reg A1EN;
    reg [4:0] B1ADDR;
    reg CLK1;
    wire B1DATA;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1ADDR(A1ADDR),
        .A1DATA(A1DATA),
        .A1EN(A1EN),
        .B1ADDR(B1ADDR),
        .CLK1(CLK1),
        .B1DATA(B1DATA)
    );

    // Clock generation (10ns period)
    initial begin
        CLK1 = 0;
        forever #5 CLK1 = ~CLK1;
    end

        task reset_dut;

        begin
            A1ADDR = 5'b0;
            A1DATA = 1'b0;
            A1EN   = 1'b0;
            B1ADDR = 5'b0;
            @(posedge CLK1);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write 1 to Address 0 and Read", test_num);
            reset_dut();


            A1ADDR = 5'd0;
            A1DATA = 1'b1;
            A1EN   = 1'b1;
            @(posedge CLK1);
            #2;
            A1EN   = 1'b0;


            B1ADDR = 5'd0;
            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write 0 to Address 31 and Read", test_num);
            reset_dut();


            A1ADDR = 5'd31;
            A1DATA = 1'b1;
            A1EN   = 1'b1;
            @(posedge CLK1);
            #2;


            A1DATA = 1'b0;
            @(posedge CLK1);
            #2;
            A1EN = 1'b0;


            B1ADDR = 5'd31;
            #5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify A1EN=0 prevents writing", test_num);
            reset_dut();


            A1ADDR = 5'd10;
            A1DATA = 1'b1;
            A1EN   = 1'b1;
            @(posedge CLK1);
            #2;


            A1DATA = 1'b0;
            A1EN   = 1'b0;
            @(posedge CLK1);
            #2;


            B1ADDR = 5'd10;
            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simultaneous check of different addresses", test_num);
            reset_dut();


            A1ADDR = 5'd5;
            A1DATA = 1'b1;
            A1EN   = 1'b1;
            @(posedge CLK1);
            #2;


            A1ADDR = 5'd6;
            A1DATA = 1'b0;
            @(posedge CLK1);
            #2;
            A1EN = 1'b0;


            B1ADDR = 5'd5;
            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify output updates when B1ADDR changes", test_num);
            reset_dut();


            A1ADDR = 5'd20;
            A1DATA = 1'b1;
            A1EN   = 1'b1;
            @(posedge CLK1);
            #2;
            A1EN = 1'b0;


            A1ADDR = 5'd21;
            A1DATA = 1'b0;
            A1EN   = 1'b1;
            @(posedge CLK1);
            #2;
            A1EN = 1'b0;


            B1ADDR = 5'd20;
            #5;
            B1ADDR = 5'd21;
            #5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overwrite existing memory data", test_num);
            reset_dut();


            A1ADDR = 5'd15;
            A1DATA = 1'b0;
            A1EN   = 1'b1;
            @(posedge CLK1);
            #2;


            A1DATA = 1'b1;
            @(posedge CLK1);
            #2;
            A1EN = 1'b0;

            B1ADDR = 5'd15;
            #5;
            #1;

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
        input expected_B1DATA;
        begin
            if (expected_B1DATA === (expected_B1DATA ^ B1DATA ^ expected_B1DATA)) begin
                $display("PASS");
                $display("  Outputs: B1DATA=%b",
                         B1DATA);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B1DATA=%b",
                         expected_B1DATA);
                $display("  Got:      B1DATA=%b",
                         B1DATA);
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
        $dumpvars(0,A1ADDR, A1DATA, A1EN, B1ADDR, CLK1, B1DATA);
    end

endmodule
