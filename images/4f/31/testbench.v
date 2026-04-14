`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg [127:0] data;
    reg we;
    wire [127:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data(data),
        .we(we),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        we = 0;
        addr = 0;
        data = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Test %0d: Basic Write and Read at Address 0x00", test_num);

        addr = 8'h00;
        data = 128'hA5A5A5A5_B6B6B6B6_C7C7C7C7_D8D8D8D8;
        we = 1;
        @(posedge clk);
        #1;

        we = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(128'hA5A5A5A5_B6B6B6B6_C7C7C7C7_D8D8D8D8);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Test %0d: Basic Write and Read at Address 0x7F", test_num);

        addr = 8'h7F;
        data = 128'h55555555_AAAAAAAA_55555555_AAAAAAAA;
        we = 1;
        @(posedge clk);
        #1;

        we = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(128'h55555555_AAAAAAAA_55555555_AAAAAAAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Test %0d: Overwrite Check at Address 0x10", test_num);


        addr = 8'h10;
        data = 128'h11111111_11111111_11111111_11111111;
        we = 1;
        @(posedge clk);
        #1;


        data = 128'hFFFFFFFF_EEEEEEEE_DDDDDDDD_CCCCCCCC;
        @(posedge clk);
        #1;

        we = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(128'hFFFFFFFF_EEEEEEEE_DDDDDDDD_CCCCCCCC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Test %0d: Write Enable (we=0) Control Check", test_num);


        addr = 8'h20;
        data = 128'hDEADBEEF_CAFEBABE_00000000_12345678;
        we = 1;
        @(posedge clk);
        #1;


        we = 0;
        data = 128'h00000000_00000000_00000000_00000000;
        @(posedge clk);
        #1;


        @(posedge clk);
        #1;
        #1;

        check_outputs(128'hDEADBEEF_CAFEBABE_00000000_12345678);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Test %0d: Multi-Address Data Retention Check", test_num);


        addr = 8'h30;
        data = 128'h30303030_30303030_30303030_30303030;
        we = 1;
        @(posedge clk);
        #1;


        addr = 8'h31;
        data = 128'h31313131_31313131_31313131_31313131;
        we = 1;
        @(posedge clk);
        #1;


        we = 0;
        addr = 8'h30;
        @(posedge clk);
        #1;


        #1;



        check_outputs(128'h30303030_30303030_30303030_30303030);
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
        input [127:0] expected_out;
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
        $dumpvars(0,addr, clk, data, we, out);
    end

endmodule
