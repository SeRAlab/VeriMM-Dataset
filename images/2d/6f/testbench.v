`timescale 1ns/1ps

module crc_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg rst;
    wire [7:0] crc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc_generator dut (
        .clk(clk),
        .data(data),
        .rst(rst),
        .crc(crc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data = 8'h00;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Input 0x00", test_num);
            reset_dut();
            data = 8'h00;
            @(posedge clk);
            #2 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Input 0x01", test_num);
            reset_dut();
            data = 8'h01;
            @(posedge clk);
            #2 #1;
 check_outputs(8'h07);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Input 0x02", test_num);
            reset_dut();
            data = 8'h02;
            @(posedge clk);
            #2 #1;
 check_outputs(8'h0E);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Input 0x03", test_num);
            reset_dut();
            data = 8'h03;
            @(posedge clk);
            #2 #1;
 check_outputs(8'h09);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Input 0x04", test_num);
            reset_dut();
            data = 8'h04;
            @(posedge clk);
            #2 #1;
 check_outputs(8'h1C);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Input 0x80", test_num);
            reset_dut();
            data = 8'h80;
            @(posedge clk);
            #2 #1;
 check_outputs(8'h89);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Input 0xFF", test_num);
            reset_dut();
            data = 8'hFF;
            @(posedge clk);
            #2 #1;
 check_outputs(8'hF1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Input 0xAA", test_num);
            reset_dut();
            data = 8'hAA;
            @(posedge clk);
            #2 #1;
 check_outputs(8'h31);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Input 0x55", test_num);
            reset_dut();
            data = 8'h55;
            @(posedge clk);
            #2 #1;
 check_outputs(8'h62);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Input 0x12", test_num);
            reset_dut();
            data = 8'h12;
            @(posedge clk);
            #2 #1;
 check_outputs(8'h7E);
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
        testcase009();
        testcase010();
        
        
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
        input [7:0] expected_crc;
        begin
            if (expected_crc === (expected_crc ^ crc ^ expected_crc)) begin
                $display("PASS");
                $display("  Outputs: crc=%h",
                         crc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc=%h",
                         expected_crc);
                $display("  Got:      crc=%h",
                         crc);
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
        $dumpvars(0,clk, data, rst, crc);
    end

endmodule
