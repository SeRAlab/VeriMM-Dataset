`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] d;
    reg [3:0] en;
    reg rst;
    reg we;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .en(en),
        .rst(rst),
        .we(we),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            d = 0;
            en = 0;
            we = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Full 32-bit Write", test_num);
            reset_dut();
            @(negedge clk);
            we = 1;
            en = 4'b1111;
            d = 32'hDEADBEEF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Byte 0 Only", test_num);
            reset_dut();
            @(negedge clk);
            we = 1;
            en = 4'b0001;
            d = 32'hFFFFFFAA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h000000AA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Byte 2 Only", test_num);
            reset_dut();
            @(negedge clk);
            we = 1;
            en = 4'b0100;
            d = 32'h12345678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00340000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: WE=0 should prevent update", test_num);
            reset_dut();
            @(negedge clk);
            we = 0;
            en = 4'b1111;
            d = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Byte-by-Byte Write", test_num);
            reset_dut();


            @(negedge clk);
            we = 1; en = 4'b0001; d = 32'h00000011;
            @(posedge clk);


            @(negedge clk);
            we = 1; en = 4'b0010; d = 32'h00002200;
            @(posedge clk);


            @(negedge clk);
            we = 1; en = 4'b0100; d = 32'h00330000;
            @(posedge clk);


            @(negedge clk);
            we = 1; en = 4'b1000; d = 32'h44000000;
            @(posedge clk);

            #1;
            #1;

            check_outputs(32'h44332211);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting specific bytes", test_num);
            reset_dut();


            @(negedge clk);
            we = 1; en = 4'b1111; d = 32'hAAAAAAAA;
            @(posedge clk);


            @(negedge clk);
            we = 1; en = 4'b0110; d = 32'h11223344;
            @(posedge clk);

            #1;
            #1;

            check_outputs(32'hAA2233AA);
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
        testcase007();
        
        
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
        input [31:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, d, en, rst, we, q);
    end

endmodule
