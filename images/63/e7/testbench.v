`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [7:0] rdaddr;
    reg [7:0] wraddr;
    reg wren;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rdaddr(rdaddr),
        .wraddr(wraddr),
        .wren(wren),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wren = 0;
            data_in = 8'h0;
            wraddr = 8'h0;
            rdaddr = 8'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read (Addr 0)", test_num);


            wren = 1;
            wraddr = 8'd0;
            data_in = 8'hA5;
            @(posedge clk);
            #1;


            wren = 0;
            rdaddr = 8'd0;
            #2;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address Write and Read (Addr 7)", test_num);


            wren = 1;
            wraddr = 8'd7;
            data_in = 8'h5A;
            @(posedge clk);
            #1;


            wren = 0;
            rdaddr = 8'd7;
            #2;

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Verification", test_num);


            wren = 1;
            wraddr = 8'd2;
            data_in = 8'h11;
            @(posedge clk);
            #1;


            wren = 0;
            wraddr = 8'd2;
            data_in = 8'hFF;
            @(posedge clk);
            #1;


            rdaddr = 8'd2;
            #2;


            #1;



            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Register", test_num);


            wren = 1;
            wraddr = 8'd4;
            data_in = 8'hCC;
            @(posedge clk);
            #1;


            data_in = 8'h33;
            @(posedge clk);
            #1;

            wren = 0;
            rdaddr = 8'd4;
            #2;

            #1;


            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Address Independence", test_num);


            wren = 1;
            wraddr = 8'd1;
            data_in = 8'hDE;
            @(posedge clk);
            #1;


            wraddr = 8'd2;
            data_in = 8'hAD;
            @(posedge clk);
            #1;


            wren = 0;
            rdaddr = 8'd1;
            #2;

            #1;


            check_outputs(8'hDE);
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
        $dumpvars(0,clk, data_in, rdaddr, wraddr, wren, data_out);
    end

endmodule
