`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ACK_cpu;
    reg clk_cpu;
    reg rst_cpu;
    wire [31:0] outDATA_cpu;
    wire outSEND_cpu;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ACK_cpu(ACK_cpu),
        .clk_cpu(clk_cpu),
        .rst_cpu(rst_cpu),
        .outDATA_cpu(outDATA_cpu),
        .outSEND_cpu(outSEND_cpu)
    );

    // Clock generation (10ns period)
    initial begin
        clk_cpu = 0;
        forever #5 clk_cpu = ~clk_cpu;
    end

        task reset_dut;

        begin
            rst_cpu = 1;
            ACK_cpu = 1;
            @(posedge clk_cpu);
            #1;
            rst_cpu = 0;
            @(posedge clk_cpu);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            @(posedge clk_cpu);
            #1;


            #1;



            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            ACK_cpu = 0;
            @(posedge clk_cpu);
            #1;


            #1;



            check_outputs(outDATA_cpu, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            ACK_cpu = 0;
            @(posedge clk_cpu);
            #1;
            ACK_cpu = 1;
            @(posedge clk_cpu);
            #1;

            #1;


            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            ACK_cpu = 0;
            @(posedge clk_cpu);
            #1;
            rst_cpu = 1;
            @(posedge clk_cpu);
            #1;

            #1;


            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            ACK_cpu = 0;
            @(posedge clk_cpu);


            ACK_cpu = 1;
            @(posedge clk_cpu);


            ACK_cpu = 0;
            @(posedge clk_cpu);
            #1;


            #1;



            check_outputs(outDATA_cpu, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            #2 ACK_cpu = 0;
            #2 ACK_cpu = 1;

            @(posedge clk_cpu);
            #1;


            #1;



            check_outputs(32'h0, 1'b0);
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
        input [31:0] expected_outDATA_cpu;
        input expected_outSEND_cpu;
        begin
            if (expected_outDATA_cpu === (expected_outDATA_cpu ^ outDATA_cpu ^ expected_outDATA_cpu) &&
                expected_outSEND_cpu === (expected_outSEND_cpu ^ outSEND_cpu ^ expected_outSEND_cpu)) begin
                $display("PASS");
                $display("  Outputs: outDATA_cpu=%h, outSEND_cpu=%b",
                         outDATA_cpu, outSEND_cpu);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outDATA_cpu=%h, outSEND_cpu=%b",
                         expected_outDATA_cpu, expected_outSEND_cpu);
                $display("  Got:      outDATA_cpu=%h, outSEND_cpu=%b",
                         outDATA_cpu, outSEND_cpu);
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
        $dumpvars(0,ACK_cpu, clk_cpu, rst_cpu, outDATA_cpu, outSEND_cpu);
    end

endmodule
