`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] addr;
    reg clk;
    reg [197:0] data;
    reg reset;
    reg sel;
    reg w;
    wire done;
    wire [197:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data(data),
        .reset(reset),
        .sel(sel),
        .w(w),
        .done(done),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            sel = 0;
            w = 0;
            addr = 0;
            data = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Check");
            reset_dut();

            #1;


            check_outputs(1'b0, 198'b0);
        end
        endtask

    task testcase002;

        reg [197:0] test_val;
        begin
            $display("Running testcase002: Write/Read Addr 0");
            test_val = {66{3'b101}};
            reset_dut();


            sel = 1;
            w = 1;
            addr = 6'd0;
            data = test_val;
            @(posedge clk);
            #1;


            w = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, test_val);
        end
        endtask

    task testcase003;

        reg [197:0] test_val;
        begin
            $display("Running testcase003: Write/Read Addr 63");
            test_val = {198{1'b1}};
            reset_dut();


            sel = 1;
            w = 1;
            addr = 6'd63;
            data = test_val;
            @(posedge clk);
            #1;


            w = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1, test_val);
        end
        endtask

    task testcase004;

        reg [197:0] test_val;
        begin
            $display("Running testcase004: Sel=0 Check");
            test_val = 198'hDEADBEEF;
            reset_dut();


            sel = 0;
            w = 1;
            addr = 6'd10;
            data = test_val;
            @(posedge clk);
            #1;



            sel = 1;
            w = 0;
            addr = 6'd10;
            @(posedge clk);
            #1;



            if (out != test_val) begin

                pass_count = pass_count + 1;
                $display("PASS: Data was not written when sel=0");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Data was written even when sel=0");
            end
        end
        endtask

    task testcase005;

        reg [197:0] val1, val2;
        begin
            $display("Running testcase005: Overwrite check");
            val1 = 198'h11111111111111111111111111111111111111111111111111;
            val2 = 198'h22222222222222222222222222222222222222222222222222;
            reset_dut();

            sel = 1;
            w = 1;
            addr = 6'd32;
            data = val1;
            @(posedge clk); #1;

            data = val2;
            @(posedge clk); #1;

            w = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(1'b1, val2);
        end
        endtask

    task testcase006;

        reg [197:0] test_val;
        begin
            $display("Running testcase006: Read consistency");
            test_val = 198'hABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFABCDEFAB;
            reset_dut();


            sel = 1; w = 1; addr = 6'd5; data = test_val;
            @(posedge clk); #1;


            w = 0;
            @(posedge clk); #1;
            @(posedge clk); #1;
            @(posedge clk); #1;

            #1;


            check_outputs(1'b1, test_val);
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
        input expected_done;
        input [197:0] expected_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, out=%h",
                         done, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, out=%h",
                         expected_done, expected_out);
                $display("  Got:      done=%b, out=%h",
                         done, out);
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
        $dumpvars(0,addr, clk, data, reset, sel, w, done, out);
    end

endmodule
