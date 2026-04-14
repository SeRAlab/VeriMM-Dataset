`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] data;
    reg [4:0] rdaddress;
    reg [4:0] wraddress;
    reg wren;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data(data),
        .rdaddress(rdaddress),
        .wraddress(wraddress),
        .wren(wren),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            wren = 0;
            data = 0;
            wraddress = 0;
            rdaddress = 0;
            @(posedge clock);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Write and Read back", test_num);
            reset_dut();


            @(negedge clock);
            wren = 1;
            wraddress = 5'd5;
            data = 32'hABCDEF01;


            @(negedge clock);
            wren = 0;
            rdaddress = 5'd5;


            @(negedge clock);

            #1;


            check_outputs(32'hABCDEF01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Verify Write Enable (wren=0)", test_num);
            reset_dut();


            @(negedge clock);
            wren = 0;
            wraddress = 5'd10;
            data = 32'h5555AAAA;


            @(negedge clock);
            rdaddress = 5'd10;


            @(negedge clock);


            #1;



            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Simultaneous Read and Write", test_num);
            reset_dut();


            @(negedge clock);
            wren = 1;
            wraddress = 5'd2;
            data = 32'h11111111;


            @(negedge clock);
            wren = 1;
            wraddress = 5'd3;
            data = 32'h22222222;
            rdaddress = 5'd2;


            @(negedge clock);

            #1;


            check_outputs(32'h11111111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Boundary Address Test (31)", test_num);
            reset_dut();


            @(negedge clock);
            wren = 1;
            wraddress = 5'd31;
            data = 32'hFFFFFFFF;


            @(negedge clock);
            wren = 0;
            rdaddress = 5'd31;

            @(negedge clock);

            #1;


            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Consecutive Writes and Delayed Read", test_num);
            reset_dut();


            @(negedge clock);
            wren = 1;
            wraddress = 5'd10;
            data = 32'hCAFEBABE;


            @(negedge clock);
            wraddress = 5'd11;
            data = 32'hDEADBEEF;


            @(negedge clock);
            wren = 0;
            @(negedge clock);
            @(negedge clock);


            @(negedge clock);
            rdaddress = 5'd10;
            @(negedge clock);

            #1;


            check_outputs(32'hCAFEBABE);
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
        input [31:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clock, data, rdaddress, wraddress, wren, q);
    end

endmodule
