`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] address;
    reg busy;
    reg clk;
    reg full;
    reg [31:0] rda;
    reg read;
    reg reset;
    reg write;
    reg [31:0] writedata;
    wire go;
    wire [11:0] memd;
    wire memw;
    wire [31:0] readdata;
    wire tbm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .busy(busy),
        .clk(clk),
        .full(full),
        .rda(rda),
        .read(read),
        .reset(reset),
        .write(write),
        .writedata(writedata),
        .go(go),
        .memd(memd),
        .memw(memw),
        .readdata(readdata),
        .tbm(tbm)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            address = 0;
            busy = 0;
            full = 0;
            rda = 0;
            read = 0;
            write = 0;
            writedata = 0;
            reset = 1;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(0, 12'h000, 0, 32'h00000000, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Memory Write Access", test_num);
            reset_dut();
            @(negedge clk);
            address = 3'b001;
            writedata = 32'h00000ABC;
            write = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 12'hABC, 1, 32'h00000000, 0);
            write = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Trigger I2C Transaction", test_num);
            reset_dut();
            @(negedge clk);
            address = 3'b000;
            writedata = 32'h00000001;
            write = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1, 12'h000, 0, 32'h00000000, 0);
            write = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Read Data from Device", test_num);
            reset_dut();
            @(negedge clk);
            rda = 32'hDEADBEEF;
            address = 3'b010;
            read = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 12'h000, 0, 32'hDEADBEEF, 0);
            read = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Check Status Flags", test_num);
            reset_dut();
            @(negedge clk);
            busy = 1;
            full = 1;
            address = 3'b000;
            read = 1;
            @(posedge clk);
            #2;


            if (readdata != 0) begin
                $display("Status bits detected: %h", readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("Status bits not reflected in readdata");
                fail_count = fail_count + 1;
            end
            read = 0;
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
        input expected_go;
        input [11:0] expected_memd;
        input expected_memw;
        input [31:0] expected_readdata;
        input expected_tbm;
        begin
            if (expected_go === (expected_go ^ go ^ expected_go) &&
                expected_memd === (expected_memd ^ memd ^ expected_memd) &&
                expected_memw === (expected_memw ^ memw ^ expected_memw) &&
                expected_readdata === (expected_readdata ^ readdata ^ expected_readdata) &&
                expected_tbm === (expected_tbm ^ tbm ^ expected_tbm)) begin
                $display("PASS");
                $display("  Outputs: go=%b, memd=%h, memw=%b, readdata=%h, tbm=%b",
                         go, memd, memw, readdata, tbm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: go=%b, memd=%h, memw=%b, readdata=%h, tbm=%b",
                         expected_go, expected_memd, expected_memw, expected_readdata, expected_tbm);
                $display("  Got:      go=%b, memd=%h, memw=%b, readdata=%h, tbm=%b",
                         go, memd, memw, readdata, tbm);
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
        $dumpvars(0,address, busy, clk, full, rda, read, reset, write, writedata, go, memd, memw, readdata, tbm);
    end

endmodule
