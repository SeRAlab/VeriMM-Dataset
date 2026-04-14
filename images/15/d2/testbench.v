`timescale 1ns/1ps

module crc_generator_tb;

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
    crc_generator dut (
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
            data = 4'b0;
            polynomial = 4'b0;
            @(posedge clk);
            #1 rst = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data=0000, Poly=1011 (Zero Data)", test_num);
            reset_dut();
            data = 4'b0000;
            polynomial = 4'b1011;
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data=1011, Poly=0000 (Zero Poly)", test_num);
            reset_dut();
            data = 4'b1011;
            polynomial = 4'b0000;
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(4'b1011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data=1111, Poly=1011", test_num);
            reset_dut();
            data = 4'b1111;
            polynomial = 4'b1011;
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data=1001, Poly=1001 (Match)", test_num);
            reset_dut();
            data = 4'b1001;
            polynomial = 4'b1001;
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data=0111, Poly=1101 (No XOR)", test_num);
            reset_dut();
            data = 4'b0111;
            polynomial = 4'b1101;
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(4'b0111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data=1010, Poly=1100", test_num);
            reset_dut();
            data = 4'b1010;
            polynomial = 4'b1100;
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(4'b0110);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data=1000, Poly=1111", test_num);
            reset_dut();
            data = 4'b1000;
            polynomial = 4'b1111;
            repeat(4) @(posedge clk);
            #1 #1;
 check_outputs(4'b0111);
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
