`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg pon_en;
    reg [7:0] pon_in;
    reg pon_load;
    wire [7:0] pon_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pon_en(pon_en),
        .pon_in(pon_in),
        .pon_load(pon_load),
        .pon_out(pon_out)
    );

    // Clock generation (10ns period)
    initial begin
        pon_load = 0;
        forever #5 pon_load = ~pon_load;
    end

        task reset_dut;

        begin
            pon_en = 0;
            pon_in = 8'h00;

            @(negedge pon_load);
            @(negedge pon_load);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initial Value Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'b10101011);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Basic Load 0xFF", test_num);
            reset_dut();
            pon_en = 1;
            pon_in = 8'hFF;
            @(posedge pon_load);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Basic Load 0x55", test_num);
            reset_dut();
            pon_en = 1;
            pon_in = 8'h55;
            @(posedge pon_load);
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Load with pon_en low", test_num);
            reset_dut();

            pon_en = 1;
            pon_in = 8'h12;
            @(posedge pon_load);
            #2;


            pon_en = 0;
            pon_in = 8'h34;
            @(posedge pon_load);
            #2;




            #1;





            check_outputs(8'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Negative Edge Check", test_num);
            reset_dut();
            pon_en = 1;
            pon_in = 8'hA5;

            @(posedge pon_load);
            #2;

            pon_in = 8'h5A;
            @(negedge pon_load);
            #2;


            #1;



            check_outputs(8'hA5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Data Stability Check", test_num);
            reset_dut();
            pon_en = 1;
            pon_in = 8'hCC;
            @(posedge pon_load);
            #2;

            pon_in = 8'hDD;
            #2;
            pon_in = 8'hEE;
            #2;

            #1;


            check_outputs(8'hCC);
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
        input [7:0] expected_pon_out;
        begin
            if (expected_pon_out === (expected_pon_out ^ pon_out ^ expected_pon_out)) begin
                $display("PASS");
                $display("  Outputs: pon_out=%h",
                         pon_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pon_out=%h",
                         expected_pon_out);
                $display("  Got:      pon_out=%h",
                         pon_out);
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
        $dumpvars(0,pon_en, pon_in, pon_load, pon_out);
    end

endmodule
