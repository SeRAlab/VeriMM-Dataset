`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] select;
    reg [15:0] write_data;
    reg write_enable;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .select(select),
        .write_data(write_data),
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
            write_enable = 0;
            select = 0;
            write_data = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Writing 0xAAAA to Register 0", test_num);
            select = 2'b00;
            write_data = 16'hAAAA;
            write_enable = 1;
            @(posedge clk);
            #2;
            write_enable = 0;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Writing 0x5555 to Register 1", test_num);
            select = 2'b01;
            write_data = 16'h5555;
            write_enable = 1;
            @(posedge clk);
            #2;
            write_enable = 0;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Writing 0x1234 to Register 2", test_num);
            select = 2'b10;
            write_data = 16'h1234;
            write_enable = 1;
            @(posedge clk);
            #2;
            write_enable = 0;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Writing 0xBEEF to Register 3", test_num);
            select = 2'b11;
            write_data = 16'hBEEF;
            write_enable = 1;
            @(posedge clk);
            #2;
            write_enable = 0;
            #1;

            check_outputs(16'hBEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Testing persistence across register switches", test_num);

            select = 2'b00; write_data = 16'h1111; write_enable = 1; @(posedge clk); #2;

            select = 2'b11; write_data = 16'h4444; write_enable = 1; @(posedge clk); #2;

            write_enable = 0;
            select = 2'b00;
            #2;
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Testing write_enable functionality", test_num);

            select = 2'b01; write_data = 16'h7777; write_enable = 1; @(posedge clk); #2;

            write_data = 16'h9999; write_enable = 0; @(posedge clk); #2;

            #1;


            check_outputs(16'h7777);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %03d: Testing register overwrite", test_num);
            select = 2'b10; write_data = 16'hAAAA; write_enable = 1; @(posedge clk); #2;
            select = 2'b10; write_data = 16'hBBBB; write_enable = 1; @(posedge clk); #2;
            write_enable = 0;
            #1;

            check_outputs(16'hBBBB);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,clk, select, write_data, write_enable, data_out);
    end

endmodule
