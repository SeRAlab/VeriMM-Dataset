`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] address;
    reg [7:0] datain;
    reg sysclock;
    reg write_enable;
    wire [7:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .datain(datain),
        .sysclock(sysclock),
        .write_enable(write_enable),
        .dataout(dataout)
    );

    // Clock generation (10ns period)
    initial begin
        sysclock = 0;
        forever #5 sysclock = ~sysclock;
    end

        task reset_dut;

        begin
            address = 0;
            datain = 0;
            write_enable = 0;

            repeat(2) @(negedge sysclock);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read Back", test_num);
            reset_dut();


            @(negedge sysclock);
            write_enable = 1;
            address = 5'd5;
            datain = 8'hA5;


            @(negedge sysclock);
            write_enable = 0;
            address = 5'd5;


            @(posedge sysclock);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Startup Initialization Check", test_num);
            reset_dut();


            @(negedge sysclock);
            write_enable = 0;
            address = 5'd15;

            @(posedge sysclock);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Successive Writes", test_num);
            reset_dut();


            @(negedge sysclock);
            write_enable = 1; address = 5'd1; datain = 8'h11;
            @(negedge sysclock);
            write_enable = 1; address = 5'd2; datain = 8'h22;
            @(negedge sysclock);
            write_enable = 1; address = 5'd3; datain = 8'h33;


            @(negedge sysclock);
            write_enable = 0; address = 5'd2;

            @(posedge sysclock);
            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Data", test_num);
            reset_dut();


            @(negedge sysclock);
            write_enable = 1; address = 5'h10; datain = 8'hAA;

            @(negedge sysclock);
            write_enable = 1; address = 5'h10; datain = 8'hBB;


            @(negedge sysclock);
            write_enable = 0; address = 5'h10;

            @(posedge sysclock);
            #1;
            #1;

            check_outputs(8'hBB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address (31)", test_num);
            reset_dut();


            @(negedge sysclock);
            write_enable = 1; address = 5'd31; datain = 8'hFF;


            @(negedge sysclock);
            write_enable = 0; address = 5'd31;

            @(posedge sysclock);
            #1;
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_dataout;
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h",
                         expected_dataout);
                $display("  Got:      dataout=%h",
                         dataout);
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
        $dumpvars(0,address, datain, sysclock, write_enable, dataout);
    end

endmodule
