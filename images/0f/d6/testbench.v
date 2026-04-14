`timescale 1ns/1ps

module crc_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg [31:0] polynomial;
    reg rst;
    wire [31:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc_generator dut (
        .clk(clk),
        .data_in(data_in),
        .polynomial(polynomial),
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
            data_in = 32'h0;
            polynomial = 32'h0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Power-on Reset");
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Zero Data, Standard Poly (0x04C11DB7)");
            reset_dut();
            polynomial = 32'h04C11DB7;
            data_in = 32'h00000000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: All Ones Data (0xFFFFFFFF)");
            reset_dut();
            polynomial = 32'h04C11DB7;
            data_in = 32'hFFFFFFFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hCBF17506);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Pattern 0x12345678");
            reset_dut();
            polynomial = 32'h04C11DB7;
            data_in = 32'h12345678;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0A9397B4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Multi-cycle Accumulation");
            reset_dut();
            polynomial = 32'h04C11DB7;


            data_in = 32'h11223344;
            @(posedge clk);
            #1;


            data_in = 32'h55667788;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h3D2E680B);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Changing Polynomial (Alternative Poly 0x1EDC6F41)");
            reset_dut();
            polynomial = 32'h1EDC6F41;
            data_in = 32'hA5A5A5A5;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h669288E2);
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
        input [31:0] expected_crc_out;
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
        $dumpvars(0,clk, data_in, polynomial, rst, crc_out);
    end

endmodule
