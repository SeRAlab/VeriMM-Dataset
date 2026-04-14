`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr;
    reg clk;
    reg [7:0] write_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
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
            addr = 0;
            write_en = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Initial Read Operation", test_num);
            addr = 32'h0000_0000;
            write_en = 8'h00;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Unauthorized Write Attempt", test_num);


            addr = 32'h0000_0040;
            write_en = 8'h00;
            @(posedge clk);


            addr = 32'h0000_0040;
            write_en = 8'hFF;
            @(posedge clk);


            write_en = 8'h00;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Authorized Write Attempt", test_num);


            addr = 32'h0000_0080;

            write_en = AUTH_CODE;
            @(posedge clk);


            write_en = 8'h00;
            repeat(2) @(posedge clk);
            #1;



            if (data_out !== 8'h00) begin
                pass_count = pass_count + 1;
                $display("PASS: Data modified with correct authorization");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Data remained 0 despite correct authorization");
            end
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Segment Boundary Check (Addr 63)", test_num);

            addr = 32'd63;
            write_en = AUTH_CODE;
            @(posedge clk);

            write_en = 8'h00;
            repeat(2) @(posedge clk);
            #1;

            if (data_out !== 8'h00) begin
                $display("PASS: Boundary write successful");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Boundary write failed");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Out of Range Address Check", test_num);


            addr = 32'd2048;
            write_en = AUTH_CODE;
            @(posedge clk);

            write_en = 8'h00;
            repeat(2) @(posedge clk);
            #1;

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
        $dumpvars(0,addr, clk, write_en, data_out);
    end

endmodule
