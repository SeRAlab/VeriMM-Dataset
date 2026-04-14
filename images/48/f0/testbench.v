`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] read_address;
    reg [7:0] w_data;
    reg w_en;
    reg [4:0] write_address;
    wire [7:0] r_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .read_address(read_address),
        .w_data(w_data),
        .w_en(w_en),
        .write_address(write_address),
        .r_data(r_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            w_en = 0;
            write_address = 0;
            w_data = 0;
            read_address = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            w_en = 1;
            write_address = 5'h05;
            w_data = 8'hAA;
            @(posedge clk);
            #1;
            w_en = 0;


            read_address = 5'h05;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Writes", test_num);
            reset_dut();


            w_en = 1; write_address = 5'h10; w_data = 8'h11;
            @(posedge clk); #1;

            w_en = 1; write_address = 5'h11; w_data = 8'h22;
            @(posedge clk); #1;
            w_en = 0;


            read_address = 5'h11;
            @(posedge clk); #2;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Check", test_num);
            reset_dut();


            w_en = 1; write_address = 5'h01; w_data = 8'h55;
            @(posedge clk); #1;


            w_en = 0; write_address = 5'h01; w_data = 8'hFF;
            @(posedge clk); #1;


            read_address = 5'h01;
            @(posedge clk); #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Address Boundary Check", test_num);
            reset_dut();

            w_en = 1; write_address = 5'd31; w_data = 8'hE7;
            @(posedge clk); #1;
            w_en = 0;

            read_address = 5'd31;
            @(posedge clk); #2;
            #1;

            check_outputs(8'hE7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Read/Write", test_num);
            reset_dut();


            w_en = 1; write_address = 5'h02; w_data = 8'hBB;
            @(posedge clk); #1;


            w_en = 1; write_address = 5'h03; w_data = 8'hCC;
            read_address = 5'h02;
            @(posedge clk); #2;

            #1;


            check_outputs(8'hBB);
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
        input [7:0] expected_r_data;
        begin
            if (expected_r_data === (expected_r_data ^ r_data ^ expected_r_data)) begin
                $display("PASS");
                $display("  Outputs: r_data=%h",
                         r_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r_data=%h",
                         expected_r_data);
                $display("  Got:      r_data=%h",
                         r_data);
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
        $dumpvars(0,clk, read_address, w_data, w_en, write_address, r_data);
    end

endmodule
