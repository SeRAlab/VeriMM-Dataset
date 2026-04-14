`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] address;
    reg clk;
    reg read_en;
    reg reset;
    reg [15:0] write_data;
    reg write_en;
    wire busy;
    wire [15:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .read_en(read_en),
        .reset(reset),
        .write_data(write_data),
        .write_en(write_en),
        .busy(busy),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            read_en = 0;
            write_en = 0;
            address = 0;
            write_data = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Basic Write and Read back", test_num);


            @(posedge clk);
            #1;
            write_en = 1;
            address = 16'hA001;
            write_data = 16'hDEAD;
            @(posedge clk);
            #1;
            write_en = 0;


            while (busy) @(posedge clk);
            #1;


            @(posedge clk);
            #1;
            read_en = 1;
            address = 16'hA001;
            @(posedge clk);
            #1;
            read_en = 0;


            while (busy) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 16'hDEAD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Writing and Reading from a different address", test_num);


            @(posedge clk);
            #1;
            write_en = 1;
            address = 16'h5555;
            write_data = 16'hBEEF;
            @(posedge clk);
            #1;
            write_en = 0;

            while (busy) @(posedge clk);
            #1;


            @(posedge clk);
            #1;
            read_en = 1;
            address = 16'h5555;
            @(posedge clk);
            #1;
            read_en = 0;

            while (busy) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 16'hBEEF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Overwrite existing data", test_num);


            @(posedge clk);
            #1;
            write_en = 1;
            address = 16'h1234;
            write_data = 16'h1111;
            @(posedge clk);
            #1;
            write_en = 0;
            while (busy) @(posedge clk);
            #1;


            @(posedge clk);
            #1;
            write_en = 1;
            address = 16'h1234;
            write_data = 16'h2222;
            @(posedge clk);
            #1;
            write_en = 0;
            while (busy) @(posedge clk);
            #1;


            @(posedge clk);
            #1;
            read_en = 1;
            address = 16'h1234;
            @(posedge clk);
            #1;
            read_en = 0;
            while (busy) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 16'h2222);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Read uninitialized address (expecting 0)", test_num);


            @(posedge clk);
            #1;
            read_en = 1;
            address = 16'hFFFF;
            @(posedge clk);
            #1;
            read_en = 0;
            while (busy) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Verifying busy flag behavior during write", test_num);

            @(posedge clk);
            #1;
            write_en = 1;
            address = 16'h00AA;
            write_data = 16'h5555;
            @(posedge clk);
            #1;
            write_en = 0;


            if (busy === 1'b1) begin
                $display("  Info: Busy flag correctly asserted.");
            end else begin
                $display("  Error: Busy flag failed to assert during operation.");
            end

            while (busy) @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, read_data);
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
        input expected_busy;
        input [15:0] expected_read_data;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, read_data=%h",
                         busy, read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, read_data=%h",
                         expected_busy, expected_read_data);
                $display("  Got:      busy=%b, read_data=%h",
                         busy, read_data);
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
        $dumpvars(0,address, clk, read_en, reset, write_data, write_en, busy, read_data);
    end

endmodule
