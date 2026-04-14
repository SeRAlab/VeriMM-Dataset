`timescale 1ns/1ps

module crc_calculator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data;
    reg [3:0] polynomial;
    reg rst;
    wire [3:0] crc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc_calculator dut (
        .clk(clk),
        .data(data),
        .polynomial(polynomial),
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
            data = 0;
            polynomial = 0;
            @(posedge clk);
            #1 rst = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Data, Poly 0x3", test_num);
            reset_dut();
            data = 4'h0;
            polynomial = 4'h3;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data 0x8 (1000), Poly 0x3 (0011)", test_num);
            reset_dut();
            data = 4'h8;
            polynomial = 4'h3;
            @(posedge clk);

            #1 #1;
 check_outputs(4'hB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones Data (0xF), Poly 0xF", test_num);
            reset_dut();
            data = 4'hF;
            polynomial = 4'hF;
            @(posedge clk);

            #1 #1;
 check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits Data 0xA, Poly 0x9", test_num);
            reset_dut();
            data = 4'hA;
            polynomial = 4'h9;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data 0x7, Poly 0x1", test_num);
            reset_dut();
            data = 4'h7;
            polynomial = 4'h1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc_calculator Testbench");
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
        input [3:0] expected_crc;
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
        $dumpvars(0,clk, data, polynomial, rst, crc);
    end

endmodule
