`timescale 1ns/1ps

module subtractor_8bit_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg rst_n;
    wire borrow_out;
    wire [7:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    subtractor_8bit dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst_n(rst_n),
        .borrow_out(borrow_out),
        .diff(diff)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            a = 0;
            b = 0;
            @(posedge clk);
            #1 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            a = 8'd50;
            b = 8'd20;
            @(posedge clk);
            #1;
            $display("Testcase %03d: 50 - 20", test_num);
            #1;

            check_outputs(1'b0, 8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            a = 8'hFF;
            b = 8'hFF;
            @(posedge clk);
            #1;
            $display("Testcase %03d: 255 - 255", test_num);
            #1;

            check_outputs(1'b0, 8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            a = 8'd10;
            b = 8'd15;
            @(posedge clk);
            #1;
            $display("Testcase %03d: 10 - 15 (Should borrow)", test_num);

            #1;


            check_outputs(1'b1, 8'hFB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            a = 8'd0;
            b = 8'd1;
            @(posedge clk);
            #1;
            $display("Testcase %03d: 0 - 1", test_num);
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            a = 8'hFF;
            b = 8'h00;
            @(posedge clk);
            #1;
            $display("Testcase %03d: 255 - 0", test_num);
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            rst_n = 0;
            a = 8'd100;
            b = 8'd50;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Reset functionality", test_num);
            #1;

            check_outputs(1'b0, 8'd0);
            rst_n = 1;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("subtractor_8bit Testbench");
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
        input expected_borrow_out;
        input [7:0] expected_diff;
        begin
            if (expected_borrow_out === (expected_borrow_out ^ borrow_out ^ expected_borrow_out) &&
                expected_diff === (expected_diff ^ diff ^ expected_diff)) begin
                $display("PASS");
                $display("  Outputs: borrow_out=%b, diff=%h",
                         borrow_out, diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: borrow_out=%b, diff=%h",
                         expected_borrow_out, expected_diff);
                $display("  Got:      borrow_out=%b, diff=%h",
                         borrow_out, diff);
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
        $dumpvars(0,a, b, clk, rst_n, borrow_out, diff);
    end

endmodule
