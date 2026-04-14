`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clock;
    reg [7:0] data_in;
    reg reset;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clock(clock),
        .data_in(data_in),
        .reset(reset),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            addr = 0;
            data_in = 0;
            @(posedge clock);
            #2;
            reset = 0;
            @(posedge clock);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read at Address 0x0", test_num);
            reset_dut();

            addr = 4'h0;
            data_in = 8'hA5;
            @(posedge clock);

            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write and Read at Boundary Address 0xF", test_num);
            reset_dut();

            addr = 4'hF;
            data_in = 8'h5A;
            @(posedge clock);

            #2;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting Data at Address 0x5", test_num);
            reset_dut();


            addr = 4'h5;
            data_in = 8'h11;
            @(posedge clock);


            addr = 4'h5;
            data_in = 8'h22;
            @(posedge clock);

            #2;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Write and Random Access Read", test_num);
            reset_dut();


            addr = 4'h2;
            data_in = 8'hBB;
            @(posedge clock);


            addr = 4'h8;
            data_in = 8'hCC;
            @(posedge clock);


            #1;
            addr = 4'h2;
            #2;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset verification (Clear State)", test_num);
            reset_dut();


            addr = 4'h7;
            data_in = 8'hFF;
            @(posedge clock);


            reset = 1;
            @(posedge clock);
            #2;
            reset = 0;


            addr = 4'h7;
            #2;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rapid Write Sequence", test_num);
            reset_dut();

            addr = 4'h0; data_in = 8'h01; @(posedge clock);
            addr = 4'h1; data_in = 8'h02; @(posedge clock);
            addr = 4'h2; data_in = 8'h03; @(posedge clock);
            addr = 4'h3; data_in = 8'h04; @(posedge clock);

            #1;
            addr = 4'h3;
            #2;
            #1;

            check_outputs(8'h04);
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,addr, clock, data_in, reset, data_out);
    end

endmodule
