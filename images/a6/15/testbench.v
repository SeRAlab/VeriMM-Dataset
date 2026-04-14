`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [17:0] address_i;
    reg [1:0] be_i;
    reg clk_i;
    reg [15:0] data_i;
    reg wren_i;
    wire [15:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address_i(address_i),
        .be_i(be_i),
        .clk_i(clk_i),
        .data_i(data_i),
        .wren_i(wren_i),
        .data_o(data_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            address_i = 0;
            be_i = 0;
            data_i = 0;
            wren_i = 0;
            @(posedge clk_i);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write and Read full word", test_num);

            address_i = 18'hA5;
            data_i = 16'hABCD;
            be_i = 2'b11;
            wren_i = 1;

            @(posedge clk_i);
            #1;
            wren_i = 0;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write lower byte only", test_num);


            address_i = 18'h10;
            data_i = 16'h0000;
            be_i = 2'b11;
            wren_i = 1;
            @(posedge clk_i);


            address_i = 18'h10;
            data_i = 16'hFF22;
            be_i = 2'b01;
            wren_i = 1;
            @(posedge clk_i);
            #1;
            wren_i = 0;

            #1;


            check_outputs(16'h0022);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Write upper byte only", test_num);


            address_i = 18'h20;
            data_i = 16'h0000;
            be_i = 2'b11;
            wren_i = 1;
            @(posedge clk_i);


            address_i = 18'h20;
            data_i = 16'h33FF;
            be_i = 2'b10;
            wren_i = 1;
            @(posedge clk_i);
            #1;
            wren_i = 0;

            #1;


            check_outputs(16'h3300);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verify wren_i=0 prevents writing", test_num);


            address_i = 18'h30;
            data_i = 16'h5555;
            be_i = 2'b11;
            wren_i = 1;
            @(posedge clk_i);


            address_i = 18'h30;
            data_i = 16'hAAAA;
            be_i = 2'b11;
            wren_i = 0;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential byte updates on same address", test_num);

            address_i = 18'h40;


            data_i = 16'h1111;
            be_i = 2'b11;
            wren_i = 1;
            @(posedge clk_i);


            data_i = 16'h0022;
            be_i = 2'b01;
            @(posedge clk_i);


            data_i = 16'h3300;
            be_i = 2'b10;
            @(posedge clk_i);

            #1;
            wren_i = 0;
            #1;

            check_outputs(16'h3322);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Verification of multiple addresses", test_num);


            address_i = 18'h100;
            data_i = 16'hAAAA;
            be_i = 2'b11;
            wren_i = 1;
            @(posedge clk_i);


            address_i = 18'h200;
            data_i = 16'hBBBB;
            be_i = 2'b11;
            wren_i = 1;
            @(posedge clk_i);


            wren_i = 0;
            address_i = 18'h100;
            #5;
            #1;

            check_outputs(16'hAAAA);
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
        input [15:0] expected_data_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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
        $dumpvars(0,address_i, be_i, clk_i, data_i, wren_i, data_o);
    end

endmodule
