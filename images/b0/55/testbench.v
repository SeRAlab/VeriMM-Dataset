`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg enable;
    reg read_city;
    reg [2:0] select;
    wire [1:0] city;
    wire city_done_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .read_city(read_city),
        .select(select),
        .city(city),
        .city_done_out(city_done_out)
    );

    // Clock generation (10ns period)
    initial begin
        enable = 0;
        forever #5 enable = ~enable;
    end

        task reset_dut;

        begin
            read_city = 0;
            select = 3'b000;

            @(posedge enable);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            read_city = 1;
            select = 3'b000;
            @(posedge enable);
            #2;
            #1;

            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            read_city = 1;
            select = 3'b001;
            @(posedge enable);
            #2;
            #1;

            check_outputs(2'b01, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            read_city = 1;
            select = 3'b010;
            @(posedge enable);
            #2;
            #1;

            check_outputs(2'b10, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            read_city = 1;
            select = 3'b011;
            @(posedge enable);
            #2;
            #1;

            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            read_city = 1;
            select = 3'b111;
            @(posedge enable);
            #2;
            #1;

            check_outputs(2'b00, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            read_city = 0;
            select = 3'b001;
            @(posedge enable);
            #2;

            #1;


            check_outputs(city, 1'b0);
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
        input [1:0] expected_city;
        input expected_city_done_out;
        begin
            if (expected_city === (expected_city ^ city ^ expected_city) &&
                expected_city_done_out === (expected_city_done_out ^ city_done_out ^ expected_city_done_out)) begin
                $display("PASS");
                $display("  Outputs: city=%h, city_done_out=%b",
                         city, city_done_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: city=%h, city_done_out=%b",
                         expected_city, expected_city_done_out);
                $display("  Got:      city=%h, city_done_out=%b",
                         city, city_done_out);
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
        $dumpvars(0,enable, read_city, select, city, city_done_out);
    end

endmodule
