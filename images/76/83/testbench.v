`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg arst;
    reg clk;
    reg [7:0] d;
    reg en;
    reg ld;
    reg srst;
    wire lz;
    wire [7:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .arst(arst),
        .clk(clk),
        .d(d),
        .en(en),
        .ld(ld),
        .srst(srst),
        .lz(lz),
        .z(z)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            arst = 1;
            srst = 0;
            en = 0;
            ld = 0;
            d = 8'h00;
            #15;
            arst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Asynchronous Reset", test_num);

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Basic Load Operation (en=1, ld=1)", test_num);
            @(posedge clk);
            en = 1;
            ld = 1;
            d = 8'hA5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Enable Gating (en=0, ld=1)", test_num);
            @(posedge clk);
            en = 0;
            ld = 1;
            d = 8'hFF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Load Gating (en=1, ld=0)", test_num);
            @(posedge clk);
            en = 1;
            ld = 0;
            d = 8'h55;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Synchronous Reset", test_num);

            @(posedge clk);
            en = 1;
            ld = 1;
            d = 8'hDE;
            @(posedge clk);
            #2;

            en = 1;
            srst = 1;
            @(posedge clk);
            #2;
            srst = 0;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Testcase %0d: Data Persistence", test_num);

            @(posedge clk);
            en = 1;
            ld = 1;
            d = 8'h77;
            @(posedge clk);
            #2;

            ld = 0;
            d = 8'hEE;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 8'h77);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            $display("Testcase %0d: Async Reset Priority", test_num);
            @(posedge clk);
            en = 1;
            ld = 1;
            d = 8'hBB;

            #3;
            arst = 1;
            #2;
            #1;

            check_outputs(1'b0, 8'h00);
            arst = 0;
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            $display("Testcase %0d: Consecutive Loads", test_num);
            @(posedge clk);
            en = 1;
            ld = 1;
            d = 8'h11;
            @(posedge clk);
            #1;
            d = 8'h22;
            @(posedge clk);
            #1;
            d = 8'h33;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 8'h33);
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
        testcase008();
        
        
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
        input expected_lz;
        input [7:0] expected_z;
        begin
            if (expected_lz === (expected_lz ^ lz ^ expected_lz) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: lz=%b, z=%h",
                         lz, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lz=%b, z=%h",
                         expected_lz, expected_z);
                $display("  Got:      lz=%b, z=%h",
                         lz, z);
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
        $dumpvars(0,arst, clk, d, en, ld, srst, lz, z);
    end

endmodule
