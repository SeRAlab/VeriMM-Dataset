`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] address;
    reg [7:0] data_in;
    reg write_enable;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .data_in(data_in),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        write_enable = 0;
        forever #5 write_enable = ~write_enable;
    end

        task reset_dut;

        begin
            address = 0;
            data_in = 0;

            @(negedge write_enable);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Write and Read-back (Addr: 0x10, Data: 0xA5)", test_num);
            reset_dut();


            address = 8'h10;
            data_in = 8'hA5;
            @(posedge write_enable);



            @(negedge write_enable);
            address = 8'h10;
            data_in = 8'h00;
            @(posedge write_enable);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Address Integrity", test_num);
            reset_dut();


            address = 8'h20;
            data_in = 8'h55;
            @(posedge write_enable);


            @(negedge write_enable);
            address = 8'h30;
            data_in = 8'hAA;
            @(posedge write_enable);


            @(negedge write_enable);
            address = 8'h20;
            data_in = 8'h00;
            @(posedge write_enable);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overwriting data at Addr 0x40", test_num);
            reset_dut();


            address = 8'h40;
            data_in = 8'h11;
            @(posedge write_enable);


            @(negedge write_enable);
            address = 8'h40;
            data_in = 8'h22;
            @(posedge write_enable);


            @(negedge write_enable);
            address = 8'h40;
            @(posedge write_enable);
            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Address Check (0xFF)", test_num);
            reset_dut();

            address = 8'hFF;
            data_in = 8'h99;
            @(posedge write_enable);

            @(negedge write_enable);
            address = 8'hFF;
            @(posedge write_enable);
            #1;
            #1;

            check_outputs(8'h99);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Read-Before-Write (Old Data) Verification", test_num);
            reset_dut();


            address = 8'h50;
            data_in = 8'h66;
            @(posedge write_enable);


            @(negedge write_enable);
            address = 8'h50;
            data_in = 8'h77;
            @(posedge write_enable);
            #1;
            #1;

            check_outputs(8'h66);
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
        $dumpvars(0,address, data_in, write_enable, data_out);
    end

endmodule
