`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] address;
    reg clk;
    reg [7:0] data_in;
    reg write_enable;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            address = 3'b0;
            data_in = 8'b0;
            write_enable = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            address = 3'd3;
            data_in = 8'hA5;
            write_enable = 1;
            @(posedge clk);
            #1;


            write_enable = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Address Read/Write", test_num);
            reset_dut();


            address = 3'd0; data_in = 8'h11; write_enable = 1;
            @(posedge clk); #1;


            address = 3'd7; data_in = 8'h22; write_enable = 1;
            @(posedge clk); #1;


            write_enable = 0;
            address = 3'd0;
            @(posedge clk); #1;
            if (data_out !== 8'h11) begin
                #1;

                check_outputs(8'h11);
            end else begin

                address = 3'd7;
                @(posedge clk); #1;
                #1;

                check_outputs(8'h22);
            end
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Data", test_num);
            reset_dut();


            address = 3'd4;
            data_in = 8'hAA;
            write_enable = 1;
            @(posedge clk); #1;


            data_in = 8'h55;
            @(posedge clk); #1;


            write_enable = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Validation", test_num);
            reset_dut();


            address = 3'd2;
            data_in = 8'hCC;
            write_enable = 1;
            @(posedge clk); #1;


            write_enable = 0;
            data_in = 8'hEE;
            @(posedge clk); #1;


            address = 3'd2;
            @(posedge clk); #1;
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full Memory Fill and Final Read", test_num);
            reset_dut();


            write_enable = 1;
            for (i = 0; i < 8; i = i + 1) begin
                address = i;
                data_in = i + 8'h10;
                @(posedge clk); #1;
            end


            write_enable = 0;
            address = 3'd7;
            @(posedge clk); #1;
            #1;

            check_outputs(8'h17);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_Cell Testbench");
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
        $dumpvars(0,address, clk, data_in, write_enable, data_out);
    end

endmodule
