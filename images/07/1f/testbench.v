`timescale 1ns/1ps

module crc_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    wire [7:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc_generator dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .crc_out(crc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 8'h00;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Data = 0x00", test_num);
            reset_dut();
            data_in = 8'h00;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Data = 0x01", test_num);
            reset_dut();
            data_in = 8'h01;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h07);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Data = 0x02", test_num);
            reset_dut();
            data_in = 8'h02;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h0E);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Data = 0x03", test_num);
            reset_dut();
            data_in = 8'h03;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h09);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Data = 0x10", test_num);
            reset_dut();
            data_in = 8'h10;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h70);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Data = 0x55", test_num);
            reset_dut();
            data_in = 8'h55;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hBE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Data = 0xAA", test_num);
            reset_dut();
            data_in = 8'hAA;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h4F);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Data = 0xFF", test_num);
            reset_dut();
            data_in = 8'hFF;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hF1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc_generator Testbench");
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
        input [7:0] expected_crc_out;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h",
                         crc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h",
                         expected_crc_out);
                $display("  Got:      crc_out=%h",
                         crc_out);
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
        $dumpvars(0,clk, data_in, rst, crc_out);
    end

endmodule
