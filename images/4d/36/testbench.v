`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] w_bus_addr_in;
    reg w_clock;
    reg w_reset;
    wire [7:0] r_bus_addr_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .w_bus_addr_in(w_bus_addr_in),
        .w_clock(w_clock),
        .w_reset(w_reset),
        .r_bus_addr_out(r_bus_addr_out)
    );

    // Clock generation (10ns period)
    initial begin
        w_clock = 0;
        forever #5 w_clock = ~w_clock;
    end

        task reset_dut;

        begin
            w_reset = 1;
            w_bus_addr_in = 8'h00;
            @(posedge w_clock);
            #1;
            w_reset = 0;
            @(posedge w_clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Functionality", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write 0xAA to Bus", test_num);
            reset_dut();
            w_bus_addr_in = 8'hAA;
            @(posedge w_clock);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write 0x55 to Bus", test_num);
            reset_dut();
            w_bus_addr_in = 8'h55;
            @(posedge w_clock);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Value 0xFF", test_num);
            reset_dut();
            w_bus_addr_in = 8'hFF;
            @(posedge w_clock);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Persistence/Sequential Check", test_num);
            reset_dut();


            w_bus_addr_in = 8'h12;
            @(posedge w_clock);
            #1;


            w_bus_addr_in = 8'h34;
            #2;


            #1;



            check_outputs(8'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Priority", test_num);
            reset_dut();


            w_bus_addr_in = 8'h77;
            @(posedge w_clock);
            #1;


            w_reset = 1;
            @(posedge w_clock);
            #1;
            w_reset = 0;


            #1;



            check_outputs(8'h00);
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
        input [7:0] expected_r_bus_addr_out;
        begin
            if (expected_r_bus_addr_out === (expected_r_bus_addr_out ^ r_bus_addr_out ^ expected_r_bus_addr_out)) begin
                $display("PASS");
                $display("  Outputs: r_bus_addr_out=%h",
                         r_bus_addr_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r_bus_addr_out=%h",
                         expected_r_bus_addr_out);
                $display("  Got:      r_bus_addr_out=%h",
                         r_bus_addr_out);
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
        $dumpvars(0,w_bus_addr_in, w_clock, w_reset, r_bus_addr_out);
    end

endmodule
