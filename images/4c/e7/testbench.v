`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr_i;
    reg cen_i;
    reg clk;
    reg [31:0] data_i;
    reg oen_i;
    reg wen_i;
    wire [31:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_i(addr_i),
        .cen_i(cen_i),
        .clk(clk),
        .data_i(data_i),
        .oen_i(oen_i),
        .wen_i(wen_i),
        .data_o(data_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        cen_i = 1'b1;
        oen_i = 1'b1;
        wen_i = 1'b1;
        addr_i = 8'h00;
        data_i = 32'h0;
        repeat(2) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Running Testcase001: Basic Write and Read...");


        @(negedge clk);
        cen_i = 1'b0; wen_i = 1'b0; addr_i = 8'h0A; data_i = 32'hDEADBEEF;
        @(posedge clk);
        #1;


        cen_i = 1'b0; wen_i = 1'b1; oen_i = 1'b0; addr_i = 8'h0A;
        @(posedge clk);
        #2;

        #1;


        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Running Testcase002: Multiple Address Integrity...");


        @(negedge clk);
        cen_i = 0; wen_i = 0; addr_i = 8'h01; data_i = 32'hAAAA_AAAA;
        @(posedge clk);


        @(negedge clk);
        cen_i = 0; wen_i = 0; addr_i = 8'h02; data_i = 32'h5555_5555;
        @(posedge clk);


        @(negedge clk);
        cen_i = 0; wen_i = 1; oen_i = 0; addr_i = 8'h01;
        @(posedge clk);
        #2;

        #1;


        check_outputs(32'hAAAA_AAAA);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Running Testcase003: Overwriting Data...");


        @(negedge clk);
        cen_i = 0; wen_i = 0; addr_i = 8'hFF; data_i = 32'h1111_2222;
        @(posedge clk);


        @(negedge clk);
        data_i = 32'h3333_4444;
        @(posedge clk);


        @(negedge clk);
        wen_i = 1; oen_i = 0;
        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h3333_4444);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Running Testcase004: Chip Enable Inhibition...");


        @(negedge clk);
        cen_i = 0; wen_i = 0; addr_i = 8'h20; data_i = 32'h6666_6666;
        @(posedge clk);


        @(negedge clk);
        cen_i = 1; wen_i = 0; addr_i = 8'h20; data_i = 32'h9999_9999;
        @(posedge clk);


        @(negedge clk);
        cen_i = 0; wen_i = 1; oen_i = 0; addr_i = 8'h20;
        @(posedge clk);
        #2;


        #1;



        check_outputs(32'h6666_6666);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Running Testcase005: Write Enable Inhibition...");


        @(negedge clk);
        cen_i = 0; wen_i = 0; addr_i = 8'h30; data_i = 32'h7777_7777;
        @(posedge clk);


        @(negedge clk);
        wen_i = 1; addr_i = 8'h30; data_i = 32'hBBBB_BBBB;
        @(posedge clk);


        @(negedge clk);
        oen_i = 0; addr_i = 8'h30;
        @(posedge clk);
        #2;


        #1;



        check_outputs(32'h7777_7777);
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
        input [31:0] expected_data_o;
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
        $dumpvars(0,addr_i, cen_i, clk, data_i, oen_i, wen_i, data_o);
    end

endmodule
