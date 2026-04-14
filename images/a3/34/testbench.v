`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] Data;
    reg clk;
    reg enable;
    wire [4:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Data(Data),
        .clk(clk),
        .enable(enable),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            Data = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Capturing Data 5'h15 with enable=1", test_num);

            Data = 5'h15;
            enable = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Verify no capture when enable=0", test_num);


            Data = 5'h0A;
            enable = 1;
            @(posedge clk);
            #1;


            Data = 5'h1F;
            enable = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(5'h0A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Capture boundary value 5'h1F", test_num);

            Data = 5'h1F;
            enable = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Capture boundary value 5'h00", test_num);


            Data = 5'h0E;
            enable = 1;
            @(posedge clk);
            #1;

            Data = 5'h00;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Multiple consecutive writes", test_num);

            enable = 1;
            Data = 5'h01; @(posedge clk); #1;
            Data = 5'h02; @(posedge clk); #1;
            Data = 5'h04; @(posedge clk); #1;
            Data = 5'h08; @(posedge clk); #1;
            Data = 5'h10; @(posedge clk); #1;

            #1;
            #1;

            check_outputs(5'h10);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Data stability and edge sensitivity", test_num);

            enable = 1;
            Data = 5'h12;
            @(posedge clk);
            #2;

            Data = 5'h00;
            #2;


            #1;



            check_outputs(5'h12);
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
        input [4:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,Data, clk, enable, Q);
    end

endmodule
