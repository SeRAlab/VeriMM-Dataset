`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg [20:0] data;
    reg we;
    wire [20:0] out;

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
            $display("Test %0d: Basic Write and Read", test_num);
            addr = 8'h05;
            data = 21'h1A5A5A;
            we = 1;
            @(posedge clk);
            #2;
            we = 0;
            #1;

            check_outputs(21'h1A5A5A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Boundary Address (0xFF)", test_num);
            addr = 8'hFF;
            data = 21'h0FFFFF;
            we = 1;
            @(posedge clk);
            #2;
            we = 0;
            #1;

            check_outputs(21'h0FFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Write Enable (we) Control", test_num);


            addr = 8'h10;
            data = 21'h111111;
            we = 1;
            @(posedge clk);


            #2;
            we = 0;
            data = 21'h222222;
            @(posedge clk);

            #2;
            #1;

            check_outputs(21'h111111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Overwriting data", test_num);

            addr = 8'h20;
            data = 21'h000001;
            we = 1;
            @(posedge clk);

            #2;
            data = 21'h1FFFFF;
            @(posedge clk);

            #2;
            we = 0;
            #1;

            check_outputs(21'h1FFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Multi-address Data Retention", test_num);


            addr = 8'hAA;
            data = 21'h0AAAAA;
            we = 1;
            @(posedge clk);


            #2;
            addr = 8'hBB;
            data = 21'h0BBBBB;
            @(posedge clk);


            #2;
            we = 0;
            addr = 8'hAA;
            #2;
            #1;

            check_outputs(21'h0AAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: All Zeros and All Ones Integrity", test_num);

            addr = 8'h55;
            data = 21'h000000;
            we = 1;
            @(posedge clk);

            #2;
            addr = 8'hAA;
            data = 21'h1FFFFF;
            @(posedge clk);

            #2;
            we = 0;
            addr = 8'h55;
            #2;
            if (out !== 21'h000000) begin
                #1;

                check_outputs(21'h000000);
            end else begin
                addr = 8'hAA;
                #2;
                #1;

                check_outputs(21'h1FFFFF);
            end
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
        input [20:0] expected_out;
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
