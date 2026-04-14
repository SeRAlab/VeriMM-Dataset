`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg read_en;
    reg [2:0] read_reg1;
    reg [2:0] read_reg2;
    reg [31:0] write_data;
    reg write_en;
    reg [2:0] write_reg;
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .read_en(read_en),
        .read_reg1(read_reg1),
        .read_reg2(read_reg2),
        .write_data(write_data),
        .write_en(write_en),
        .write_reg(write_reg),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        integer i;
        begin
            @(negedge clk);
            write_en = 0;
            read_en = 0;
            write_reg = 0;
            write_data = 0;
            read_reg1 = 0;
            read_reg2 = 0;
            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                write_en = 1;
                write_reg = i;
                write_data = 32'h0;
            end
            @(negedge clk);
            write_en = 0;
            $display("Reset: All registers cleared to 0.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Write and Read", test_num);
            reset_dut();


            @(negedge clk);
            write_en = 1;
            write_reg = 3'd1;
            write_data = 32'hABCDE001;


            @(negedge clk);
            write_en = 0;
            read_en = 1;
            read_reg1 = 3'd1;
            read_reg2 = 3'd1;

            #2;
            #1;

            check_outputs(32'hABCDE001, 32'hABCDE001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Write and Dual Port Read", test_num);
            reset_dut();


            @(negedge clk);
            write_en = 1;
            write_reg = 3'd2;
            write_data = 32'h11112222;


            @(negedge clk);
            write_reg = 3'd5;
            write_data = 32'h5555AAAA;


            @(negedge clk);
            write_en = 0;
            read_en = 1;
            read_reg1 = 3'd2;
            read_reg2 = 3'd5;

            #2;
            #1;

            check_outputs(32'h11112222, 32'h5555AAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write Enable Logic Check", test_num);
            reset_dut();


            @(negedge clk);
            write_en = 1;
            write_reg = 3'd3;
            write_data = 32'h77777777;


            @(negedge clk);
            write_en = 0;
            write_reg = 3'd3;
            write_data = 32'hFFFFFFFF;


            @(negedge clk);
            read_en = 1;
            read_reg1 = 3'd3;
            read_reg2 = 3'd3;

            #2;
            #1;

            check_outputs(32'h77777777, 32'h77777777);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simultaneous Read and Write", test_num);
            reset_dut();


            @(negedge clk);
            write_en = 1;
            write_reg = 3'd4;
            write_data = 32'h44444444;


            @(negedge clk);
            write_en = 1;
            write_reg = 3'd7;
            write_data = 32'h77777777;
            read_en = 1;
            read_reg1 = 3'd4;
            read_reg2 = 3'd7;

            @(negedge clk);
            write_en = 0;
            read_reg1 = 3'd4;
            read_reg2 = 3'd7;

            #2;
            #1;

            check_outputs(32'h44444444, 32'h77777777);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Read Cleared Registers", test_num);
            reset_dut();

            @(negedge clk);
            read_en = 1;
            read_reg1 = 3'd0;
            read_reg2 = 3'd6;

            #2;
            #1;

            check_outputs(32'h0, 32'h0);
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
        input [31:0] expected_read_data1;
        input [31:0] expected_read_data2;
        begin
            if (expected_read_data1 === (expected_read_data1 ^ read_data1 ^ expected_read_data1) &&
                expected_read_data2 === (expected_read_data2 ^ read_data2 ^ expected_read_data2)) begin
                $display("PASS");
                $display("  Outputs: read_data1=%h, read_data2=%h",
                         read_data1, read_data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data1=%h, read_data2=%h",
                         expected_read_data1, expected_read_data2);
                $display("  Got:      read_data1=%h, read_data2=%h",
                         read_data1, read_data2);
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
        $dumpvars(0,clk, read_en, read_reg1, read_reg2, write_data, write_en, write_reg, read_data1, read_data2);
    end

endmodule
