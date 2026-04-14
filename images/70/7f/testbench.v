`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr_b;
    reg clk;
    reg [31:0] data_b_in;
    reg [31:0] data_b_we;
    reg rst;
    wire vga_dump;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_b(addr_b),
        .clk(clk),
        .data_b_in(data_b_in),
        .data_b_we(data_b_we),
        .rst(rst),
        .vga_dump(vga_dump)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            addr_b = 0;
            data_b_in = 0;
            data_b_we = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Assert vga_dump on addr 65599 with WE", test_num);
            reset_dut();

            addr_b = 32'd65599;
            data_b_we = 32'hFFFFFFFF;
            data_b_in = 32'hDEADBEEF;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: vga_dump must clear on the next cycle", test_num);
            reset_dut();


            addr_b = 32'd65599;
            data_b_we = 32'hFFFFFFFF;
            @(posedge clk);


            #1;
            addr_b = 0;
            data_b_we = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Wrong address (65598) should not trigger", test_num);
            reset_dut();

            addr_b = 32'd65598;
            data_b_we = 32'hFFFFFFFF;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: WE=0 should not trigger", test_num);
            reset_dut();

            addr_b = 32'd65599;
            data_b_we = 32'h00000000;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Reset active should prevent trigger", test_num);
            reset_dut();

            rst = 1;
            addr_b = 32'd65599;
            data_b_we = 32'hFFFFFFFF;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Successive trigger checks", test_num);
            reset_dut();


            addr_b = 32'd65599;
            data_b_we = 32'hFFFFFFFF;
            @(posedge clk); #1;


            addr_b = 0;
            data_b_we = 0;
            @(posedge clk); #1;


            addr_b = 32'd65599;
            data_b_we = 32'hFFFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
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
        input expected_vga_dump;
        begin
            if (expected_vga_dump === (expected_vga_dump ^ vga_dump ^ expected_vga_dump)) begin
                $display("PASS");
                $display("  Outputs: vga_dump=%b",
                         vga_dump);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vga_dump=%b",
                         expected_vga_dump);
                $display("  Got:      vga_dump=%b",
                         vga_dump);
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
        $dumpvars(0,addr_b, clk, data_b_in, data_b_we, rst, vga_dump);
    end

endmodule
