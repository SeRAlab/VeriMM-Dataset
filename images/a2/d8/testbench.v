`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    reg [1:0] ena;
    reg load;
    wire [2:0] final_output;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .ena(ena),
        .load(load),
        .final_output(final_output),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 1;
            data = 16'h0000;
            ena = 2'b00;
            #10;
            load = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();

            load = 1;
            data = 16'hAAAA;
            #10;
            load = 0;


            #1;



            check_outputs(3'h5, 16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();

            load = 1;
            data = 16'h0001;
            #10;
            load = 0;

            @(posedge clk);
            ena = 2'b01;
            @(posedge clk);
            #1;
            ena = 2'b00;



            #1;




            check_outputs(3'h7, 16'h8000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();

            load = 1;
            data = 16'h8000;
            #10;
            load = 0;

            @(posedge clk);
            ena = 2'b10;
            @(posedge clk);
            #1;
            ena = 2'b00;



            #1;




            check_outputs(3'h6, 16'h0001);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            reset_dut();

            load = 1;
            data = 16'h1234;
            #10;
            load = 0;

            @(posedge clk);
            ena = 2'b01;
            for(i=0; i<8; i=i+1) begin
                @(posedge clk);
            end
            #1;
            ena = 2'b00;



            #1;




            check_outputs(3'h5, 16'h3412);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            reset_dut();

            load = 1;
            data = 16'hFEDC;
            #10;
            load = 0;

            @(posedge clk);
            ena = 2'b10;
            for(i=0; i<16; i=i+1) begin
                @(posedge clk);
            end
            #1;
            ena = 2'b00;



            #1;




            check_outputs(3'h3, 16'hFEDC);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();

            load = 1;
            data = 16'h00FF;
            #10;
            load = 0;

            @(posedge clk);
            ena = 2'b10;
            @(posedge clk);
            ena = 2'b10;
            @(posedge clk);
            ena = 2'b01;
            @(posedge clk);
            #1;
            ena = 2'b00;


            #1;



            check_outputs(3'h1, 16'h01FE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();


            load = 1;
            data = 16'hFFF8;
            #10;
            load = 0;
            #10;
            #1;

            check_outputs(3'h7, 16'hFFF8);


            load = 1;
            data = 16'h0007;
            #10;
            load = 0;
            #10;
            #1;

            check_outputs(3'h0, 16'h0007);
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
        input [2:0] expected_final_output;
        input [15:0] expected_q;
        begin
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h, q=%h",
                         final_output, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h, q=%h",
                         expected_final_output, expected_q);
                $display("  Got:      final_output=%h, q=%h",
                         final_output, q);
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
        $dumpvars(0,clk, data, ena, load, final_output, q);
    end

endmodule
