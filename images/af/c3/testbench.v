`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address;
    reg chipselect;
    reg clk;
    reg in_port;
    reg reset_n;
    reg write_n;
    reg [31:0] writedata;
    wire [31:0] readdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .chipselect(chipselect),
        .clk(clk),
        .in_port(in_port),
        .reset_n(reset_n),
        .write_n(write_n),
        .writedata(writedata),
        .readdata(readdata)
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
            chipselect = 0;
            write_n = 1;
            writedata = 0;
            in_port = 0;
            @(posedge clk);
            @(posedge clk);
            #1 reset_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Reading current input port (Address 0)", test_num);


            in_port = 0;
            address = 2'b00;
            chipselect = 1;
            write_n = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00000000);


            in_port = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00000001);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Rising edge detection (Address 1)", test_num);


            address = 2'b01;
            chipselect = 1;
            @(posedge clk);
            #1 if (readdata !== 32'h0) begin

            end


            in_port = 0;
            @(posedge clk);
            in_port = 1;
            @(posedge clk);

            address = 2'b01;
            chipselect = 1;
            #1 #1;
 check_outputs(32'h00000001);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Clear edge register via write", test_num);


            in_port = 0; @(posedge clk);
            in_port = 1; @(posedge clk);


            address = 2'b01;
            chipselect = 1;
            write_n = 1;
            #1 if (readdata === 32'h1) $display("  Edge Captured");


            address = 2'b01;
            chipselect = 1;
            write_n = 0;
            writedata = 32'hFFFFFFFF;
            @(posedge clk);


            write_n = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Edge persistence", test_num);


            in_port = 0; @(posedge clk);
            in_port = 1; @(posedge clk);
            in_port = 0; @(posedge clk);
            repeat(3) @(posedge clk);


            address = 2'b01;
            chipselect = 1;
            #1 #1;
 check_outputs(32'h00000001);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Chipselect check", test_num);

            in_port = 1;
            address = 2'b00;
            chipselect = 0;
            @(posedge clk);



            chipselect = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00000001);
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
        input [31:0] expected_readdata;
        begin
            if (expected_readdata === (expected_readdata ^ readdata ^ expected_readdata)) begin
                $display("PASS");
                $display("  Outputs: readdata=%h",
                         readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: readdata=%h",
                         expected_readdata);
                $display("  Got:      readdata=%h",
                         readdata);
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
        $dumpvars(0,address, chipselect, clk, in_port, reset_n, write_n, writedata, readdata);
    end

endmodule
