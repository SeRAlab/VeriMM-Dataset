`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [19:0] cpu_addr;
    reg [31:0] cpu_dout;
    reg cpu_rnw;
    reg ext_cs_b;
    reg [15:0] ram_data_in;
    reg reset_b;
    wire cpu_clken;
    wire [31:0] ext_dout;
    wire [17:0] ram_addr;
    wire ram_cs_b;
    wire ram_data_oe;
    wire [15:0] ram_data_out;
    wire ram_oe_b;
    wire ram_we_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .cpu_addr(cpu_addr),
        .cpu_dout(cpu_dout),
        .cpu_rnw(cpu_rnw),
        .ext_cs_b(ext_cs_b),
        .ram_data_in(ram_data_in),
        .reset_b(reset_b),
        .cpu_clken(cpu_clken),
        .ext_dout(ext_dout),
        .ram_addr(ram_addr),
        .ram_cs_b(ram_cs_b),
        .ram_data_oe(ram_data_oe),
        .ram_data_out(ram_data_out),
        .ram_oe_b(ram_oe_b),
        .ram_we_b(ram_we_b)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset_b = 0;
            cpu_addr = 0;
            cpu_dout = 0;
            cpu_rnw = 1;
            ext_cs_b = 1;
            ram_data_in = 0;
            #20;
            reset_b = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Idle State Check");
            reset_dut();
            test_num = 1;
            @(posedge clock);
            ext_cs_b = 1;
            repeat(2) @(posedge clock);


            #1;



            check_outputs(1'b1, 32'h0, 18'h0, 1'b1, 1'b0, 16'h0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: 32-bit Write Operation");
            reset_dut();
            test_num = 2;

            @(posedge clock);
            ext_cs_b = 0;
            cpu_rnw = 0;
            cpu_addr = 20'h40000;
            cpu_dout = 32'hDEADBEEF;




            repeat(4) @(posedge clock);




            #1;





            check_outputs(1'b1, 32'h0, 18'h20001, 1'b1, 1'b0, 16'hDEAD, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: 32-bit Read Operation");
            reset_dut();
            test_num = 3;

            @(posedge clock);
            ext_cs_b = 0;
            cpu_rnw = 1;
            cpu_addr = 20'h80000;

            @(posedge clock);
            ram_data_in = 16'h1234;
            @(posedge clock);
            ram_data_in = 16'h5678;
            @(posedge clock);



            #1;




            check_outputs(1'b1, 32'h56781234, 18'h40001, 1'b1, 1'b0, 16'h0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Consecutive Operations");
            reset_dut();
            test_num = 4;


            @(posedge clock);
            ext_cs_b = 0;
            cpu_rnw = 0;
            cpu_addr = 20'hAAAAA;
            cpu_dout = 32'h88889999;
            repeat(4) @(posedge clock);


            ext_cs_b = 0;
            cpu_rnw = 1;
            cpu_addr = 20'hBBBBB;
            @(posedge clock);
            ram_data_in = 16'hCCCC;
            @(posedge clock);
            ram_data_in = 16'hDDDD;
            @(posedge clock);

            #1;


            check_outputs(1'b1, 32'hDDDDCCCC, 18'h5DDEE, 1'b1, 1'b0, 16'h0, 1'b1, 1'b1);
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
        input expected_cpu_clken;
        input [31:0] expected_ext_dout;
        input [17:0] expected_ram_addr;
        input expected_ram_cs_b;
        input expected_ram_data_oe;
        input [15:0] expected_ram_data_out;
        input expected_ram_oe_b;
        input expected_ram_we_b;
        begin
            if (expected_cpu_clken === (expected_cpu_clken ^ cpu_clken ^ expected_cpu_clken) &&
                expected_ext_dout === (expected_ext_dout ^ ext_dout ^ expected_ext_dout) &&
                expected_ram_addr === (expected_ram_addr ^ ram_addr ^ expected_ram_addr) &&
                expected_ram_cs_b === (expected_ram_cs_b ^ ram_cs_b ^ expected_ram_cs_b) &&
                expected_ram_data_oe === (expected_ram_data_oe ^ ram_data_oe ^ expected_ram_data_oe) &&
                expected_ram_data_out === (expected_ram_data_out ^ ram_data_out ^ expected_ram_data_out) &&
                expected_ram_oe_b === (expected_ram_oe_b ^ ram_oe_b ^ expected_ram_oe_b) &&
                expected_ram_we_b === (expected_ram_we_b ^ ram_we_b ^ expected_ram_we_b)) begin
                $display("PASS");
                $display("  Outputs: cpu_clken=%b, ext_dout=%h, ram_addr=%h, ram_cs_b=%b, ram_data_oe=%b, ram_data_out=%h, ram_oe_b=%b, ram_we_b=%b",
                         cpu_clken, ext_dout, ram_addr, ram_cs_b, ram_data_oe, ram_data_out, ram_oe_b, ram_we_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cpu_clken=%b, ext_dout=%h, ram_addr=%h, ram_cs_b=%b, ram_data_oe=%b, ram_data_out=%h, ram_oe_b=%b, ram_we_b=%b",
                         expected_cpu_clken, expected_ext_dout, expected_ram_addr, expected_ram_cs_b, expected_ram_data_oe, expected_ram_data_out, expected_ram_oe_b, expected_ram_we_b);
                $display("  Got:      cpu_clken=%b, ext_dout=%h, ram_addr=%h, ram_cs_b=%b, ram_data_oe=%b, ram_data_out=%h, ram_oe_b=%b, ram_we_b=%b",
                         cpu_clken, ext_dout, ram_addr, ram_cs_b, ram_data_oe, ram_data_out, ram_oe_b, ram_we_b);
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
        $dumpvars(0,clock, cpu_addr, cpu_dout, cpu_rnw, ext_cs_b, ram_data_in, reset_b, cpu_clken, ext_dout, ram_addr, ram_cs_b, ram_data_oe, ram_data_out, ram_oe_b, ram_we_b);
    end

endmodule
