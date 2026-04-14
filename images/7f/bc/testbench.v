`timescale 1ns/1ps

module and_8bit_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg rst_n;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    and_8bit dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst_n(rst_n),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst_n = 0;
            a = 8'h00;
            b = 8'h00;
            @(negedge clk);
            rst_n = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: All Zeros (0x00 & 0x00)", test_num);
            a = 8'h00;
            b = 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: All Ones (0xFF & 0xFF)", test_num);
            a = 8'hFF;
            b = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Alternating Bits (0xAA & 0x55)", test_num);
            a = 8'hAA;
            b = 8'h55;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Identity (0xFF & 0xA5)", test_num);
            a = 8'hFF;
            b = 8'hA5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: High Nibble Mask (0xF0 & 0xCC)", test_num);
            a = 8'hF0;
            b = 8'hCC;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hC0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Low Nibble Mask (0x0F & 0x33)", test_num);
            a = 8'h0F;
            b = 8'h33;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Single Bit (0x80 & 0x81)", test_num);
            a = 8'h80;
            b = 8'h81;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Mixed Bits (0x12 & 0x34)", test_num);
            a = 8'h12;
            b = 8'h34;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("and_8bit Testbench");
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
        input [7:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,a, b, clk, rst_n, out);
    end

endmodule
