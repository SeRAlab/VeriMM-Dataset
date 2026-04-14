`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [14:0] address;
    reg clk;
    reg [31:0] data_in;
    reg reset_n;
    reg write_en;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .reset_n(reset_n),
        .write_en(write_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            address = 0;
            data_in = 0;
            write_en = 0;
            @(posedge clk);
            #2;
            reset_n = 1;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write/Read", test_num);
            reset_dut();


            address = 15'd10;
            data_in = 32'hABCDE001;
            write_en = 1;
            @(posedge clk);
            #2;


            write_en = 0;
            address = 15'd10;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hABCDE001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Initialization", test_num);


            reset_n = 1;
            address = 15'd5;
            data_in = 32'hFFFFFFFF;
            write_en = 1;
            @(posedge clk);
            #2;


            write_en = 0;
            @(posedge clk);
            #2;


            reset_n = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h00000000);
            reset_n = 1;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overwrite Memory", test_num);
            reset_dut();


            address = 15'd100;
            data_in = 32'h11112222;
            write_en = 1;
            @(posedge clk);
            #2;


            data_in = 32'h55556666;
            @(posedge clk);
            #2;


            write_en = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h55556666);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple Addresses", test_num);
            reset_dut();


            address = 15'd20;
            data_in = 32'hAAAA0000;
            write_en = 1;
            @(posedge clk);
            #2;


            address = 15'd50;
            data_in = 32'h0000BBBB;
            write_en = 1;
            @(posedge clk);
            #2;


            write_en = 0;
            address = 15'd20;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hAAAA0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Address (0)", test_num);
            reset_dut();

            address = 15'd0;
            data_in = 32'hCAFEFEED;
            write_en = 1;
            @(posedge clk);
            #2;

            write_en = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hCAFEFEED);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Boundary Address (1023)", test_num);
            reset_dut();

            address = 15'd1023;
            data_in = 32'hDEADBEEF;
            write_en = 1;
            @(posedge clk);
            #2;

            write_en = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hDEADBEEF);
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
        input [31:0] expected_data_out;
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
        $dumpvars(0,address, clk, data_in, reset_n, write_en, data_out);
    end

endmodule
