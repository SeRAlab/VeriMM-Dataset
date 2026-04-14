`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [12:0] p1_addr;
    reg [7:0] p1_data;
    reg p1_we;
    reg [12:0] p2_addr;
    wire [7:0] p2_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .p1_addr(p1_addr),
        .p1_data(p1_data),
        .p1_we(p1_we),
        .p2_addr(p2_addr),
        .p2_data(p2_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            p1_addr = 13'h0;
            p1_data = 8'h0;
            p1_we = 1'b0;
            p2_addr = 13'h0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            p1_addr = 13'h0100;
            p1_data = 8'h55;
            p1_we = 1'b1;
            @(posedge clk);
            #2;
            p1_we = 1'b0;


            p2_addr = 13'h0100;
            @(posedge clk);
            #2;


            #1;



            check_outputs(8'h55);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Boundary Address (6143)", test_num);
            reset_dut();


            p1_addr = 13'd6143;
            p1_data = 8'hAA;
            p1_we = 1'b1;
            @(posedge clk);
            #2;
            p1_we = 1'b0;


            p2_addr = 13'd6143;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Simultaneous Write and Read", test_num);
            reset_dut();


            p1_addr = 13'h0010;
            p1_data = 8'hBE;
            p1_we = 1'b1;
            @(posedge clk);
            #2;


            p1_addr = 13'h0020;
            p1_data = 8'hEF;
            p1_we = 1'b1;
            p2_addr = 13'h0010;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hBE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write Enable Verification", test_num);
            reset_dut();


            p1_addr = 13'd500;
            p1_data = 8'h11;
            p1_we = 1'b1;
            @(posedge clk);
            #2;


            p1_data = 8'h99;
            p1_we = 1'b0;
            @(posedge clk);
            #2;


            p2_addr = 13'd500;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Overwriting Existing Data", test_num);
            reset_dut();


            p1_addr = 13'h0ABC;
            p1_data = 13'h12;
            p1_we = 1'b1;
            @(posedge clk);
            #2;


            p1_data = 8'h34;
            @(posedge clk);
            #2;
            p1_we = 1'b0;


            p2_addr = 13'h0ABC;
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'h34);
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
        input [7:0] expected_p2_data;
        begin
            if (expected_p2_data === (expected_p2_data ^ p2_data ^ expected_p2_data)) begin
                $display("PASS");
                $display("  Outputs: p2_data=%h",
                         p2_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p2_data=%h",
                         expected_p2_data);
                $display("  Got:      p2_data=%h",
                         p2_data);
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
        $dumpvars(0,clk, p1_addr, p1_data, p1_we, p2_addr, p2_data);
    end

endmodule
